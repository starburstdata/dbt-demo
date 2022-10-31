select

    cookie_id,
    last_value(customer_id) ignore nulls over (
        partition by cookie_id order by session_started asc rows between unbounded preceding and current row
    ) as customer_id,
    session_started,
    lead(session_started, 1, current_timestamp(6)) over (partition by cookie_id order by session_started asc) as session_ended

from {{ ref("src_sessions") }}