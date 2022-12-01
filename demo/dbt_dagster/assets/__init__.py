from os.path import expanduser
from dagster_dbt import load_assets_from_dbt_project

home = expanduser("~")

DBT_PROJECT_PATH = f'{home}/Desktop/repos/dbt-trino-dagster/dbt-trino'
DBT_PROFILES = f'{home}/.dbt/'

dbt_assets = load_assets_from_dbt_project(
    project_dir=DBT_PROJECT_PATH,
    profiles_dir=DBT_PROFILES,
    use_build_command=True
)
