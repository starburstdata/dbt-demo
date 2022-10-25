select

    customer_id,
    count(1) as clicks,
    max(channel) as channel

from {{ ref("sessionized_clicks") }}
group by 1