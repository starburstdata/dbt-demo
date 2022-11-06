{% macro trino__current_timestamp() -%}
    current_timestamp(6)
{%- endmacro %}