# Running GatewayD

These are the steps to make GatewayD work for you:

1. Start the PostgreSQL database.
2. Start the Redis database for caching query results.
3. Install GatewayD and the cache plugin.
4. Configure and start GatewayD.
5. Test your setup with [`psql`](https://www.postgresql.org/docs/current/app-psql.html) or any other PostgreSQL client or driver.

For demo purposes, we'll use Docker to start the databases.

## 1. Start your PostgreSQL database

Use the following command to start a PostgreSQL database server inside a container:

```bash
docker run --rm --name postgres-test -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres
```

Note that the database container and its data will be purged when you stop it. Test you database by running the following command:

```bash
docker exec -it postgres-test psql postgresql://postgres:postgres@localhost:5432/postgres
```

You can exit `psql` by typing `Ctrl+D` or `\q` and hitting `Enter`.

## 2. Start your Redis database

Use the following command to start a Redis server inside a container:

```bash
docker run --rm --name redis-test -p 6379:6379 -d redis
```

You can verify if both of the above worked correctly by running `docker ps`.

## 3. Install GatewayD and the cache plugin

Install and extract GatewayD and the cache plugin using the following command:

```bash
mkdir gatewayd && cd gatewayd
wget https://github.com/gatewayd-io/gatewayd/releases/download/v0.6.0/gatewayd-linux-amd64-v0.6.0.tar.gz
tar xf gatewayd-linux-amd64-v0.6.0.tar.gz
wget https://github.com/gatewayd-io/gatewayd-plugin-cache/releases/download/v0.1.7/gatewayd-plugin-cache-linux-amd64-v0.1.7.tar.gz
tar xf gatewayd-plugin-cache-linux-amd64-v0.1.7.tar.gz
```

## 4. Configure and start GatewayD

Open the `gatewayd_plugins.yaml` file with your favorite editor and change the `localPath` to `./gatewayd-plugin-cache`. Also, replace the checksum to the one provided in the `checksum.txt` file. You can verify the checksum by running the following command:

```bash
sha256sum gatewayd-plugin-cache -c checksum.txt
```

If you want to see the details of what is happening behind the scenes, open the `gatewayd.io` and set the default logger's level to `debug` or `trace`.

Run the following command to start GatewayD:

```bash
./gatewayd run
```

Running GatewayD will produce this log output, which means that GatewayD is started listening on port `15432`.

```
2023-04-08T02:01:04+02:00 INF configuring client automatic mTLS plugin=gatewayd-plugin-cache
2023-04-08T02:01:04+02:00 INF Starting metrics server via HTTP over Unix domain socket endpoint=/metrics plugin=gatewayd-plugin-cache timestamp=2023-04-08T02:01:04.242+0200 unixDomainSocket=/tmp/gatewayd-plugin-cache.sock
2023-04-08T02:01:04+02:00 INF configuring server automatic mTLS plugin=gatewayd-plugin-cache timestamp=2023-04-08T02:01:04.243+0200
2023-04-08T02:01:04+02:00 INF Registering plugin hooks name=gatewayd-plugin-cache
2023-04-08T02:01:04+02:00 INF Plugin is ready name=gatewayd-plugin-cache
2023-04-08T02:01:04+02:00 INF Started the metrics merger scheduler metricsMergerPeriod=5s startDelay=1680912069
2023-04-08T02:01:04+02:00 INF Starting plugin health check scheduler healthCheckPeriod=5s
2023-04-08T02:01:04+02:00 INF Metrics are exposed address=http://localhost:2112/metrics
2023-04-08T02:01:04+02:00 INF There are clients available in the pool count=10 name=default
2023-04-08T02:01:04+02:00 INF Started the client health check scheduler healthCheckPeriod=1m0s startDelay=2023-04-08T02:02:04+02:00
2023-04-08T02:01:04+02:00 INF GatewayD is listening address=0.0.0.0:15432
2023-04-08T02:01:04+02:00 INF Started the HTTP API address=localhost:18080
2023-04-08T02:01:04+02:00 INF Started the gRPC API address=localhost:19090 network=tcp
2023-04-08T02:01:04+02:00 INF GatewayD is running pid=41568
```

## 5. Test you setup with `psql`

GatewayD is running on the host, while PostgreSQL is running inside a container. So, you need to run the following command to test it. Notice that `172.17.0.1` is the IP address of the host machine.

```bash
docker exec -it postgres-test psql postgresql://postgres:postgres@172.17.0.1:15432/postgres
```

Now you can create a table and insert data into it. Selecting the data will trigger the cache plugin to store the results in Redis and subsequent SELECT queries will be served from the cache. The moment you insert a new value into the table or update a row, all the cached values from that table will be invalidated.

```
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

You can check the cached keys using the following command.

```bash
docker exec -it redis-test redis-cli keys '*'
```

It should contain three keys like below:

```
1) "test:127.0.0.1:5432:postgres:UQAAABhzZWxlY3QgKiBmcm9tIHRlc3Q7AA=="
2) "127.0.0.1:5432:postgres:UQAAABhzZWxlY3QgKiBmcm9tIHRlc3Q7AA=="
3) "172.17.0.2:58136"
```

Now, insert a new row into the `test` table:

```
postgres=# insert into test values (1); -- The cache is invalidated.
INSERT 0 1
```

Now, check the cache keys again, and you'll see that there is only a single key, which means that the cached values are gone.
