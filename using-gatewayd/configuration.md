---
last_modified_date: 2023-11-17 17:38:16 +0100
layout: default
title: Configuration
description: GatewayD is fully configurable via various sources, including default values, YAML config files, environment variables, CLI flags and plugins.
nav_order: 1
parent: Using GatewayD
---

# Configuration

GatewayD is fully configurable via various sources, including default values, YAML config files, environment variables, CLI flags and plugins. This is the order in which the config parameters are applied. Plugins override the global configs and has the highest precedence overall, which means the plugin default values have the lowest precedence.

1. Plugin default values. ⬇️
2. Plugin config file: `gatewayd_plugins.yaml`.
3. Environment variables for plugins.
4. Global default values.
5. Global config file: `gatewayd.yaml`.
6. Environment variables for global config.
7. Global config updated by plugins via the `OnConfigLoaded` hooks. ⬆️

## Generating and validating config files

You can generate the default global and plugins config files using the `gatewayd config init` and `gatewayd plugin init` commands. The generated files will be placed in the current working directory, unless you specify a different location using the `--config` or `--plugin-config` flags.

To validate the global and plugins config files, you can use the `gatewayd config lint` and `gatewayd plugin lint` commands. The `--config` and `--plugin-config` flags can be used to specify the location of the config files.

## Global configuration

Global configuration contains all the config parameters for managing a running GatewayD instance. It includes parameters for configuring:

- [Loggers](/using-gatewayd/global-configuration/loggers)
- [Metrics](/using-gatewayd/global-configuration/metrics)
- [Clients](/using-gatewayd/global-configuration/clients)
- [Pools](/using-gatewayd/global-configuration/pools)
- [Proxies](/using-gatewayd/global-configuration/proxies)
- [Servers](/using-gatewayd/global-configuration/servers)
- [API](/using-gatewayd/global-configuration/api)

This is the complete global config file with the default values:

```yaml
# ⬇️ Configuration file

loggers: # ⬅️ Configuration object
  default: # ⬅️ Configuration group
    # Configuration parameters ⬇️
    output: ["console"] # "stdout", "stderr", "syslog", "rsyslog" and "file"
    level: "info" # panic, fatal, error, warn, info (default), debug, trace
    noColor: False
    timeFormat: "unix" # unixms, unixmicro and unixnano
    consoleTimeFormat: "RFC3339" # Go time format string
    # If output is file, the following fields are used.
    fileName: "gatewayd.log"
    maxSize: 500 # MB
    maxBackups: 5
    maxAge: 30 # days
    compress: True
    localTime: False
    # Rsyslog config
    rsyslogNetwork: "tcp"
    rsyslogAddress: "localhost:514"
    syslogPriority: "info" # emerg, alert, crit, err, warning, notice, debug

metrics:
  default:
    enabled: True
    address: localhost:9090
    path: /metrics
    readHeaderTimeout: 10s
    timeout: 10s
    certFile: ""
    keyFile: ""

clients:
  default:
    network: tcp
    address: localhost:5432
    tcpKeepAlive: False
    tcpKeepAlivePeriod: 30s # duration
    receiveChunkSize: 8192
    receiveDeadline: 0s # duration, 0ms/0s means no deadline
    receiveTimeout: 0s # duration, 0ms/0s means no timeout
    sendDeadline: 0s # duration, 0ms/0s means no deadline
    dialTimeout: 60s # duration, 0ms/0s means no timeout
    # Retry configuration
    retries: 3 # 0 means no retry
    backoff: 1s # duration
    backoffMultiplier: 2.0 # 0 means no backoff
    disableBackoffCaps: false

pools:
  default:
    size: 10

proxies:
  default:
    elastic: False
    reuseElasticClients: False
    healthCheckPeriod: 60s # duration

servers:
  default:
    network: tcp
    address: 0.0.0.0:15432
    enableTicker: False
    tickInterval: 5s # duration
    enableTLS: False
    certFile: ""
    keyFile: ""
    handshakeTimeout: 5s # duration

api:
  enabled: True
  httpAddress: localhost:18080
  grpcNetwork: tcp
  grpcAddress: localhost:19090
```

## Plugins configuration

GatewayD supports plugins. Plugins configuration is called `gatewayd_plugins.yaml`, which contains both the general configurations that manage plugins and the configuration of plugins themselves, which are explained in the following pages:

- [General configuration](/using-gatewayd/plugins-configuration/general-configurations)
- [Plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration)

This is the complete plugins config file with the default values and an example plugin: [gatewayd-plugin-cache](/plugins/gatewayd-plugin-cache):

```yaml
verificationPolicy: "passdown"
compatibilityPolicy: "strict"
acceptancePolicy: "accept"
terminationPolicy: "stop"
enableMetricsMerger: True
metricsMergerPeriod: 5s
healthCheckPeriod: 5s
reloadOnCrash: True
timeout: 30s
startTimeout: 1m
plugins:
  - name: gatewayd-plugin-cache
    enabled: True
    localPath: ../gatewayd-plugin-cache/gatewayd-plugin-cache
    args: ["--log-level", "debug"]
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
    checksum: 28456728dd3427b91d2e22f38b909526355d1b2becc9379581e1b70bb9495aa9
```

## Environment variables

All configuration parameters have a corresponding environment variables, except in certain cases. All environment variables are prefixed with `GATEWAYD` and are in snake case. For example, the `GATEWAYD_LOGGERS_DEFAULT_OUTPUT` environment variable can be set to the outputs required by the default logger and consists of four parts:

1. Prefix: all environment variables are prefixed with `GATEWAYD`.
2. Object: the configuration object, in this case `LOGGERS`.
3. Group: the configuration group, in this case `DEFAULT`.
4. Parameter: the configuration parameter, in this case `OUTPUT`.

```mermaid
flowchart TD
    A(GATEWAYD_LOGGERS_DEFAULT_OUTPUT)
    A --> GATEWAYD
    A --> LOGGERS
    A --> DEFAULT
    A --> OUTPUT
    GATEWAYD --> Prefix
    LOGGERS --> Object
    DEFAULT --> Group
    OUTPUT --> Parameter
```

## Runtime configuration

GatewayD allows plugins to update the global configuration at runtime. This is done by calling the `OnConfigLoaded` hook, which is called after the global configuration is loaded. The `OnConfigLoaded` hook is called on startup with the global configuration as a parameter. The plugin can then modify the global configuration and return it. The modified global configuration will be used by GatewayD.

An example of this update can be found in the [Go plugin template](https://github.com/gatewayd-io/plugin-template-go/blob/981b36aa62b4ba059656c6dde08f67a9206c0948/plugin/plugin.go#L54-L129). The following snippet shows how to update the global configuration at runtime:

```go
func (p *Plugin) OnConfigLoaded(ctx context.Context, req *v1.Struct) (*v1.Struct, error) {
  if req.Fields == nil {
    req.Fields = make(map[string]*v1.Value)
  }

  req.Fields["loggers.default.level"] = v1.NewStringValue("debug")
  req.Fields["loggers.default.noColor"] = v1.NewBoolValue(false)

  return req, nil
}
```
