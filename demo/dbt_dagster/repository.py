from dagster_dbt import dbt_cli_resource
from dbt_dagster import assets
from dbt_dagster.assets import DBT_PROFILES, DBT_PROJECT_PATH
from dbt_dagster.jobs.dbt_trino_job import dbt_trino_job
from dbt_dagster.schedules.dbt_trino_schedule import dbt_trino_schedule

from dagster import load_assets_from_package_module, repository, with_resources


@repository
def dbt_trino_dagster_assets():
    return with_resources(
        load_assets_from_package_module(assets),
        {
            "dbt": dbt_cli_resource.configured(
                {
                    "project_dir": DBT_PROJECT_PATH,
                    "profiles_dir": DBT_PROFILES,
                },
            ),
        },
    )


@repository
def dbt_trino_dagster_jobs():
    jobs = [dbt_trino_job]
    schedules = [dbt_trino_schedule]
    return jobs + schedules
