{% snapshot orders_snapshot %}
    {{ config(
        check_cols=['most_recent_order_date'], unique_key='customer_id', strategy='check',
        target_database=database, target_schema=schema
    ) }}
    select * from {{ ref("orders") }}
{% endsnapshot %}