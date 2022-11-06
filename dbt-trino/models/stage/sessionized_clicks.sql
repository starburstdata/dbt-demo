{{
    config(
        materialized='incremental',
        unique_key="clickid",
        incremental_strategy='merge',
    )
}}

with sessions as (
    
    select

        date_diff('hour', lag(c.eventtime) over w, c.eventtime) > 1 as new_session,
        {{ dbt_utils.star(ref("src_clicks"), "c") }},
        {{ dbt_utils.star(ref("customer_sessions"), "s", ["session_started", "session_ended"]) }},
        first_value(c.referrer) ignore nulls over (partition by s.customer_id order by c.eventtime asc rows between unbounded preceding and current row) as channel,
        row_number() over w as clickid,
        min(eventtime) over w as session_started,
        max(eventtime) over w as session_ended
    
    from {{ ref("src_clicks") }} c
    join {{ ref("customer_sessions") }} s ON c.visitorid = s.cookie_id and c.eventtime between s.session_started and s.session_ended
    window w AS (
        partition by c.visitorid order by c.eventtime
    )

),

sequenced_sessions as (

    select
        {{ dbt_utils.star(ref("src_clicks")) }},
        sum(if(new_session, 1, 0)) over w AS session_sequence,
        clickid,
        customer_id,
        session_started,
        session_ended,
        channel
    from sessions
    window w AS (
        partition by visitorid order by eventtime
    )
)

select
    visitorid || '_' || cast(session_sequence as varchar) || '_' || cast(clickid as varchar) as clickid,
    visitorid || '_' || cast(session_sequence as varchar) as sessionid,
    customer_id,
    session_started,
    session_ended,
    channel,
    {{ dbt_utils.star(ref("src_clicks")) }}
from sequenced_sessions
