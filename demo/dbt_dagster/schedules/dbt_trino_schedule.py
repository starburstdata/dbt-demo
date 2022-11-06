from dagster import schedule
from dbt_dagster.jobs.dbt_trino_job import dbt_trino_job


@schedule(cron_schedule='0 6 * * *', job=dbt_trino_job, execution_timezone='Poland')
def dbt_trino_schedule(_context):
    """
    A schedule definition. The schedule runs everyday at 6AM Poland time.
    """
    run_config = {}
    return run_config
