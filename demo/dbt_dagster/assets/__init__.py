import os.path
from dagster_dbt import load_assets_from_dbt_project

# the dbt-trino example exists off of the project root directory which
# is up three levels, [dbt-demo]/demo/dbt-dagster/assets/__init__.py
BASE_PROJECT_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))


# these are required for setting up DBT to work with Dagster
DBT_PROJECT_PATH = os.path.join(BASE_PROJECT_PATH, "dbt-trino")

# point PROFILES to local project directory with the profiles.yml file
DBT_PROFILES = os.path.join(BASE_PROJECT_PATH, "profiles")

dbt_assets = load_assets_from_dbt_project(
    project_dir=DBT_PROJECT_PATH,
    profiles_dir=DBT_PROFILES,
    use_build_command=True
)
