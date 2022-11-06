from dagster_dbt import load_assets_from_dbt_project

DBT_PROJECT_PATH = '/Users/przemyslawdenkiewicz/Desktop/repos/dbt-trino-dagster/dbt-trino'
DBT_PROFILES = '/Users/przemyslawdenkiewicz/.dbt/'

dbt_assets = load_assets_from_dbt_project(
    project_dir=DBT_PROJECT_PATH,
    profiles_dir=DBT_PROFILES,
    use_build_command=True
)
