from dagster import job, graph
from dagster_dbt import dbt_seed_op, dbt_run_op, dbt_test_op, dbt_cli_resource
from dbt_dagster.assets import DBT_PROJECT_PATH

local_dbt_config = dbt_cli_resource.configured({
        'project_dir': DBT_PROJECT_PATH,
    })


@job(resource_defs={"dbt": local_dbt_config})
def dbt_trino_job():
    dbt_test_op(dbt_run_op(dbt_seed_op()))
