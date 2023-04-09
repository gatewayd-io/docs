# Configuration

GatewayD is fully configurable via various sources, including default values, YAML config files, environment variables, CLI flags and plugins. This is the order in which the config parameters are applied. Plugins override the global configs and has the highest precedence overall, which means the plugin default values have the lowest precedence.

1. Plugin default values. ⬇️
2. Plugin config file: `gatewayd_plugins.yaml`.
3. Environment variables for plugins.
4. Global default values.
5. Global config file: `gatewayd.yaml`.
6. Environment variables for global config.
7. Global config updated by plugins via the `OnConfigLoaded` hooks. ⬆️

## Global configuration objects

Global configuration contains all the config parameters for managing a running GatewayD instance. It includes parameters for configuring:

- [Loggers](01-configuration/01-global-configuration/01-loggers.md)
- [Metrics](01-configuration/01-global-configuration/02-metrics.md)
- [Clients](01-configuration/01-global-configuration/03-clients.md)
- Pools
- Proxies
- Server
- API

## Configuration groups

GatewayD supports multiple configurations for any given configuration parameter listed above. There is a `default` group, which is repeated under every configuration object. Upon running `gatewayd`, it'll load the `default` values for that configuration object.

**🗒️ Note**
You can define your own configuration groups to enable multi-tenancy, but it is not needed in a typical scenario.

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
    address: localhost:2112
    path: /metrics

clients:
  default:
    network: tcp
    address: localhost:5432
    tcpKeepAlive: False
    tcpKeepAlivePeriod: 30s # duration
    receiveChunkSize: 8192
    receiveDeadline: 0s # duration, 0ms/0s means no deadline
    sendDeadline: 0s # duration, 0ms/0s means no deadline

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
    softLimit: 0
    hardLimit: 0
    enableTicker: False
    tickInterval: 5s # duration
    multiCore: True
    lockOSThread: False
    loadBalancer: roundrobin
    readBufferCap: 134217728
    writeBufferCap: 134217728
    socketRecvBuffer: 134217728
    socketSendBuffer: 134217728
    reuseAddress: True
    reusePort: True
    tcpKeepAlive: 3s # duration
    tcpNoDelay: True

api:
  enabled: True
  httpAddress: localhost:18080
  grpcNetwork: tcp
  grpcAddress: localhost:19090
```

## Plugins configuration

## Environment variables

## Runtime configuration
