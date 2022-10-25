{{
    config(
        materialized='incremental'
    )
}}

with source as (

    select * from {{ source('website', 'clicks') }}

),

renamed as (

    select

        visitorid,
        useragent,
        language,
        event,
        cast(from_iso8601_timestamp(eventtime) as timestamp(6) with time zone) as eventtime,
        page,
        referrer

    from source

)

select * from renamed

{% if is_incremental() %}

    -- this filter will only be applied on an incremental run
    where eventtime > (select max(eventtime) from {{ this }})

{% endif %}
