with order_payments as (

    select
        order_id,
        sum(amount) as total_amount

    from {{ ref('src_payments') }}

    group by order_id

),

channels_campaigns as (

    select
        channel,
        customer_id,
        cast({{ dbt_utils.get_url_parameter(field='channel', url_parameter='utm_campaign') }} as integer) as campaign_id

    from {{ ref("customer_channels") }}
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        orders.status,
        order_payments.total_amount as amount,
        channels.campaign_id,
        channel,
        country,
        age_group

    from {{ ref('src_orders') }} orders

    left join order_payments
        on orders.order_id = order_payments.order_id

    left join channels_campaigns channels
        on channels.customer_id = orders.customer_id

    left join {{ ref("campaigns") }} campaigns
        on campaigns.campaign_id = channels.campaign_id

)

select * from final
