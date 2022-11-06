{{
    config(
        materialized='incremental',
        unique_key='order_id',
        incremental_strategy='merge',
    )
}}

with source as (

    select * from {{ source('webshop', 'orders') }}

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from source

)

select * from renamed
