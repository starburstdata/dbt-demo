with source as (
    
    select * from {{ source('webshop', 'sessions') }}

),

renamed as (

    select
        cookie_id,
        cast(from_unixtime(started_ts/1000) as timestamp(6)) as session_started,
        customer_id

    from source

)

select * from renamed
