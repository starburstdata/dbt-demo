# dbt-trino Starburst blog demo

The repository contains demo assets of dbt + Trino blog post which is available on Starburst blog.
TODO: add link to post after publishing

## Run the local Trino server

```
cd docker
docker compose up -d
```

## Run the dbt commands

```
dbt seed
dbt run
dbt test
```
