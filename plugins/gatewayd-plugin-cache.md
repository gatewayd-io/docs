---
last_modified_date: 2024-03-10 23:47:43
layout: default
title: gatewayd-plugin-cache
description: GatewayD plugin for caching query results in Redis.
nav_order: 1
parent: Plugins
---

# gatewayd-plugin-cache

The gatewayd-plugin-cache is a GatewayD plugin for caching query results in Redis and this is how it works:

1. The plugin listens for incoming queries from the client(s).
2. When a new client connects to GatewayD, the plugin detects the client's selected database from the client's startup message. The client's database is cached in Redis.
3. If the query is a SELECT query, the plugin checks whether the query results are cached in Redis or not. If they are, the plugin returns the cached results to the client. Otherwise, the plugin executes the query and caches the results in Redis.
4. Any query that updates the cached data triggers the plugin to invalidate the cached data in Redis.
5. Expiry time can be set on cached data to prevent stale data from being returned to the client.
6. If a client is abruptly disconnected, stale keys might be left behind in Redis. A periodic cache invalidator runs every minute (configurable) to invalidate those stale keys.

## Features

- Basic caching of database responses to client queries
- Invalidate cached responses by parsing incoming queries (table-based):
  - **DML**: INSERT, UPDATE and DELETE
  - **Multi-statements**: UNION, INTERSECT and EXCEPT
  - **DDL**: TRUNCATE, DROP and ALTER
  - **WITH clause**
  - **Multiple queries** (delimited by semicolon)
- Periodic cache invalidation for invalidating stale client keys
- Support for setting expiry time on cached data
- Support for caching responses from multiple databases on multiple servers
- Detect client's chosen database from the client's startup message
- Prometheus metrics for quantifying cache hits, misses, gets, sets, deletes and scans
- Prometheus metrics for counting total RPC method calls
- Logging
- Configurable via environment variables

## Installation

It is assumed that you have already installed PostgreSQL, Redis and [GatewayD](/getting-started/installation).

{: .note }
> The plugin is compatible with Linux, Windows and macOS.

### Automatic installation

The latest version of the plugin can be installed automatically by running the following command. This command downloads and installs the latest version of the plugin from [GitHub releases](https://github.com/gatewayd-io/gatewayd-plugin-cache/releases) to the `plugins` directory in the current directory. The command will then enable the plugin automatically by copying the default [configuration](#configuration) to `gatewayd_plugins.yaml` from the project's GitHub repository.

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-cache@latest
```

### Manual installation

1. Download and install the latest version of [gatewayd-plugin-cache](https://github.com/gatewayd-io/gatewayd-plugin-cache/releases/latest) by copying the binary to a directory that is in your `PATH` or accessible to GatewayD.
2. Copy the [configuration](#configuration) to [`gatewayd_plugins.yaml`](/using-gatewayd/plugins-configuration/plugins-configuration).
3. Make sure that the configuration parameters and environment variables are correct, particularly the `localPath`, `checksum` and the `REDIS_URL`.

After installing the plugin using any of the above methods, you can start GatewayD and test the plugin by querying the database via GatewayD.

## Configuration

The plugin can be configured via environment variables or command-line arguments. For more information about other configuration parameters, see [plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration.md).

```yaml
plugins:
  - name: gatewayd-plugin-cache
    enabled: True
    localPath: ../gatewayd-plugin-cache/gatewayd-plugin-cache
    url: github.com/gatewayd-io/gatewayd-plugin-cache@latest
    args: ["--log-level", "info"]
    env:
      - MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN
      - MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872
      - REDIS_URL=redis://localhost:6379/0
      - EXPIRY=1h
      # - DEFAULT_DB_NAME=postgres
      - METRICS_ENABLED=True
      - METRICS_UNIX_DOMAIN_SOCKET=/tmp/gatewayd-plugin-cache.sock
      - METRICS_PATH=/metrics
      - PERIODIC_INVALIDATOR_ENABLED=True
      - PERIODIC_INVALIDATOR_INTERVAL=1m
      - PERIODIC_INVALIDATOR_START_DELAY=1m
      - API_ADDRESS=localhost:18080
      - EXIT_ON_STARTUP_ERROR=False
      - SENTRY_DSN=https://70eb1abcd32e41acbdfc17bc3407a543@o4504550475038720.ingest.sentry.io/4505342961123328
    checksum: 3988e10aefce2cd9b30888eddd2ec93a431c9018a695aea1cea0dac46ba91cae
```

### Environment variables

| Name                               | Description                                                                                                                                      | Default                                                                                        |
| ---------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------------------------------------------------- |
| `MAGIC_COOKIE_KEY`                 | The key for the magic cookie.                                                                                                                    | `GATEWAYD_PLUGIN`                                                                              |
| `MAGIC_COOKIE_VALUE`               | The value for the magic cookie.                                                                                                                  | `5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872`                             |
| `REDIS_URL`                        | The URL of the Redis server.                                                                                                                     | `redis://localhost:6379/0`                                                                     |
| `EXPIRY`                           | The expiry time for cached data.                                                                                                                 | `1h`                                                                                           |
| `DEFAULT_DB_NAME`                  | The default database name, in case you have a single database on your database server.                                                           | `postgres`                                                                                     |
| `METRICS_ENABLED`                  | Whether to enable metrics.                                                                                                                       | `True`                                                                                         |
| `METRICS_UNIX_DOMAIN_SOCKET`       | The path to the Unix domain socket for exposing metrics. This must be accessible to GatewayD.                                                    | `/tmp/gatewayd-plugin-cache.sock`                                                              |
| `METRICS_PATH`                     | The path for exposing metrics.                                                                                                                   | `/metrics`                                                                                     |
| `PERIODIC_INVALIDATOR_ENABLED`     | Whether to enable periodic cache invalidation. This runs every `PERIODIC_INVALIDATOR_INTERVAL` and removes stale client keys, not cached values. | `True`                                                                                         |
| `PERIODIC_INVALIDATOR_INTERVAL`    | The interval for periodic cache invalidation.                                                                                                    | `1m`                                                                                           |
| `PERIODIC_INVALIDATOR_START_DELAY` | The delay before starting periodic cache invalidation.                                                                                           | `1m`                                                                                           |
| `API_ADDRESS`                      | The address for the GatewayD REST API server.                                                                                                    | `localhost:18080`                                                                              |
| `EXIT_ON_STARTUP_ERROR`            | Whether to exit the plugin if there is an error during startup.                                                                                  | `False`                                                                                        |
| `SENTRY_DSN`                       | Sentry DSN. Set to empty string to disable Sentry.                                                                                               | `https://70eb1abcd32e41acbdfc17bc3407a543@o4504550475038720.ingest.sentry.io/4505342961123328` |

### Command-line arguments

| Name          | Description    | Default |
| ------------- | -------------- | ------- |
| `--log-level` | The log level. | `info`  |

## Build for testing

To build the plugin for development and testing, run the following command in the project's root directory after cloning the repository.

```bash
git clone git@github.com:gatewayd-io/gatewayd-plugin-cache.git
cd gatewayd-plugin-cache
make build-dev
```

Running the above commands clones the repository, changes the current directory and runs the `go mod tidy` and `go build` commands to compile and generate the plugin binary.
