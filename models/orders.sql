{{ 
    config(materialized='table') 
}}
select
    c.customer_id,
    c.first_name,
    c.last_name,
    coalesce(count(o.order_id), 0) as number_of_orders,
    min(o.order_date) as first_order_date,
    max(o.order_date) as most_recent_order_date,
    sum(p.amount) as total_received
from {{ ref("base_customers") }} c
left join {{ ref("base_orders") }} o on c.customer_id = o.customer_id
left join {{ ref("base_payments") }} p on o.order_id = p.order_id

group by 1, 2, 3
