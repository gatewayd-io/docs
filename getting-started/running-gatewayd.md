---
last_modified_date: 2024-01-29 21:30:54 +0100
layout: default
title: Running GatewayD
description: How to run GatewayD and test it with psql
nav_order: 4
parent: Getting Started
---

# Running GatewayD

These are the steps to make GatewayD work for you:

1. Start the PostgreSQL database.
2. Start the Redis database for caching query results.
3. Install GatewayD and the cache plugin.
4. Start GatewayD.
5. Test your setup with [`psql`](https://www.postgresql.org/docs/current/app-psql.html) or any other PostgreSQL client or driver.
6. Clean up.

{: .note }
> For demo purposes, we'll use Docker to start the databases. Also, you can skip step one if you already have a database up and running.

## 1. Start your PostgreSQL database

Use the following command to start a PostgreSQL database server inside a container:

```bash
docker run --rm --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```

Test your database by running the following command:

```bash
DOCKER_HOST=$(ip addr show docker0 | grep inet | grep -v inet6 | awk -F' ' '{ print $2 }' | sed 's/\/16//g')
docker exec -it postgres-test psql postgresql://postgres:postgres@${DOCKER_HOST}:5432/postgres -c "\d"
```

Since the database is just created, no relations exist.

## 2. Start your Redis database

Use the following command to start a Redis server inside a container:

```bash
docker run --rm --name redis-test -p 6379:6379 -d redis
```

Test your database by running the following command:

```bash
docker exec -it redis-test redis-cli keys '*'
```

Since the database is just created, no keys exist, so the output should be `(empty array)`. Also, you can verify if both of the above worked correctly by running `docker ps`.

## 3. Install GatewayD and the cache plugin

Download and extract GatewayD and the [gatewayd-cache-plugin](/plugins/gatewayd-plugin-cache) using the following commands:

```bash
mkdir gatewayd && cd gatewayd
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-linux-amd64-{% github_latest_release gatewayd-io/gatewayd %}.tar.gz | tar zxvf -
./gatewayd plugin install --update --backup github.com/gatewayd-io/gatewayd-plugin-cache@latest
```

The last command will do the following:

1. downloads the plugin
2. extracts the plugin files from the archive
3. installs the plugin in the `./plugins/gatewayd-plugin-cache` directory
4. creates a backup of the `gatewayd_plugins.yaml` file in the current working directory
5. updates the existing configuration for the cache plugin in the `gatewayd_plugins.yaml` file
6. cleans up the downloaded files

{: .note }

## 4. Start GatewayD

Run the following command to start GatewayD:

```bash
./gatewayd run
```

{: .note }
> If you want to see the details of what is happening behind the scenes, open the `gatewayd.yaml` in your favorite editor and set the log level of the default logger to `debug` or `trace`. Alternatively, you can set the `GATEWAYD_LOGGERS_DEFAULT_LEVEL=debug` environment variable before running GatewayD.

Running GatewayD will produce the following log output, which means that GatewayD is started and is:

1. listening on port `15432` with 10 connections to postgres in the pool.
2. running the `gatewayd-plugin-cache`.
3. having the pid `41568`.
4. exposing aggregated Prometheus metrics on `http://localhost:9090/`.
5. exposing an HTTP and a gRPC API on ports `18080` and `19090`.

```bash
2023-12-26T16:22:02+03:30 INF configuring client automatic mTLS group=default plugin=gatewayd-plugin-cache
2023-12-26T16:22:03+03:30 INF Starting metrics server via HTTP over Unix domain socket endpoint=/metrics group=default plugin=gatewayd-plugin-cache timestamp=2023-12-26T16:22:03.083+0330 unixDomainSocket=/tmp/gatewayd-plugin-cache.sock
2023-12-26T16:22:03+03:30 INF configuring server automatic mTLS group=default plugin=gatewayd-plugin-cache timestamp=2023-12-26T16:22:03.084+0330
2023-12-26T16:22:03+03:30 INF Registering plugin hooks group=default name=gatewayd-plugin-cache
2023-12-26T16:22:03+03:30 INF Plugin is ready group=default name=gatewayd-plugin-cache
2023-12-26T16:22:03+03:30 INF Started the metrics merger scheduler group=default metricsMergerPeriod=5s startDelay=2023-12-26T16:22:08+03:30
2023-12-26T16:22:03+03:30 INF Starting plugin health check scheduler group=default healthCheckPeriod=5s
2023-12-26T16:22:03+03:30 INF Metrics are exposed address=http://localhost:9090/metrics group=default readHeaderTimeout=10s timeout=10s
2023-12-26T16:22:03+03:30 INF There are clients available in the pool count=10 group=default name=default
2023-12-26T16:22:03+03:30 INF Started the client health check scheduler group=default healthCheckPeriod=1m0s startDelay=2023-12-26T16:23:03+03:30
2023-12-26T16:22:03+03:30 INF GatewayD is listening address=0.0.0.0:15432 group=default
2023-12-26T16:22:03+03:30 INF Started the HTTP API address=localhost:18080 group=default
2023-12-26T16:22:03+03:30 INF Started the gRPC API address=localhost:19090 group=default network=tcp
2023-12-26T16:22:03+03:30 INF GatewayD is running group=default pid=71426
```

{: .note }
> The `run` command automatically lints the configuration files and exits if there is an error. You can skip the linting by using the `--lint=false` flag.

## 5. Test your setup with `psql`

GatewayD is running on the host, while PostgreSQL is running inside a container. You can run the following command to test it. Notice that `${DOCKER_HOST}` holds the IP address of the host machine, that is accessible from inside the container.

```bash
DOCKER_HOST=$(ip addr show docker0 | grep inet | grep -v inet6 | awk -F' ' '{ print $2 }' | sed 's/\/16//g')
docker exec -it postgres-test psql postgresql://postgres:postgres@${DOCKER_HOST}:15432/postgres
```

Now you can create a table and insert data into it. Querying the data will trigger the cache plugin to store the results in Redis and subsequent SELECT queries will be served from the cache. The moment you insert a new value into the table or update a row, all the cached values from that table will be invalidated.

```sql
postgres=# create table test (id int);
CREATE TABLE
postgres=# insert into test values (1);
INSERT 0 1
postgres=# insert into test values (1);
INSERT 0 1
postgres=# insert into test values (1);
INSERT 0 1
postgres=# select * from test; -- This is read from the database.
 id
----
  1
  1
  1
(3 rows)

postgres=# select * from test; -- This is read from the cache.
 id
----
  1
  1
  1
(3 rows)
```

You can check the cached keys using the following command and it should contain three keys.

```bash
docker exec -it redis-test redis-cli dbsize
```

Now, insert a new row into the `test` table:

```sql
postgres=# insert into test values (1); -- The cache is invalidated.
INSERT 0 1
```

Now, check the total number of keys again, and you'll see that there is only a single key, which means that the cached values are gone.

## 6. Clean up

You can clean up all of the above by following these steps:

1. Exit `psql` by typing `Ctrl+D` or `\q` and hitting `Enter`.
2. Stop `gatewayd` gracefully by typing `Ctrl+C`.
3. Stop the container by running `docker stop postgres-test redis-test`. The containers will be removed automatically.
4. Remove the `gatewayd` directory from where you installed it by running `rm -rf $(PWD)/gatewayd`.
