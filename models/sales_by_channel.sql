with order_payments as (

    select
        order_id,
        sum(amount) as total_amount

    from {{ ref('src_payments') }}

    group by order_id

),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        order_payments.total_amount as amount,
        channel

    from {{ ref('src_orders') }} orders

    left join order_payments
        on orders.order_id = order_payments.order_id

    left join {{ ref("customer_channels") }} channels
        on channels.customer_id = orders.customer_id

)

select * from final
