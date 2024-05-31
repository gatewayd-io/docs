---
last_modified_date: 2024-05-31 20:16:38
layout: default
title: Metrics
description: GatewayD metrics configuration
nav_order: 2
parent: Global Configuration
grand_parent: Using GatewayD
---

# Metrics

GatewayD currently supports a single Prometheus metrics output. It collects, relabels and merges metrics from plugins over Unix Domain Socket and exposes them over HTTP. The aggregated metrics are accessible via [http://localhost:9090/metrics](http://localhost:9090/metrics) by default.

You can add a new [`scrape_config`](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) to your Prometheus config file to scrape the metrics from GatewayD:

```yaml
scrape_configs:
  - job_name: "gatewayd"
    static_configs:
      - targets: ["localhost:9090"]
```

## Configuration parameters

| Name              | Type              | Default value  | Possible values       | Description                                                                                                          |
| ----------------- | ----------------- | -------------- | --------------------- | -------------------------------------------------------------------------------------------------------------------- |
| enabled           | boolean           | True           | True, False           | The network protocol to use                                                                                          |
| address           | string            | localhost:9090 | Valid host:port       | The HTTP address and port to expose metrics on                                                                       |
| path              | string            | /metrics       | Valid path values     | The endpoint to expose metrics on                                                                                    |
| readHeaderTimeout | duration (string) | 10s            | Valid duration values | The maximum duration for reading the request headers. Setting this to a non-zero value will block Slowloris attacks. |
| timeout           | duration (string) | 10s            | Valid duration values | The maximum duration before timing out. This applies to writes, reads, idle and handler timeouts separately.         |
| certFile          | string            | ""             | Valid path values     | The path to the TLS certificate file                                                                                 |
| keyFile           | string            | ""             | Valid path values     | The path to the TLS key file                                                                                         |

## Built-in Metrics

The following are built-in metrics emitted by GatewayD. The namespace of all the metrics is always set to `gatewayd` and all the metrics are prefixed with `gatewayd_`. Emitted metrics from plugins are listed on their own page.

| Name                                 | Type                  | Description                                                        |
| ------------------------------------ | --------------------- | ------------------------------------------------------------------ |
| client_connections                   | Gauge                 | Number of client connections                                       |
| server_connections                   | Gauge                 | Number of server connections                                       |
| tls_connections                      | Gauge                 | Number of TLS connections                                          |
| server_ticks_fired_total             | Counter               | Total number of server ticks fired                                 |
| bytes_received_from_client           | Summary               | Number of bytes received from client                               |
| bytes_sent_to_server                 | Summary               | Number of bytes sent to server                                     |
| bytes_received_from_server           | Summary               | Number of bytes received from server                               |
| bytes_sent_to_client                 | Summary               | Number of bytes sent to client                                     |
| traffic_bytes                        | Summary               | Number of total bytes passed through GatewayD via client or server |
| plugins_loaded_total                 | Counter               | Number of plugins loaded                                           |
| plugin_hooks_registered_total        | Counter               | Number of plugin hooks registered                                  |
| plugin_hooks_executed_total          | Counter               | Number of plugin hooks executed                                    |
| proxy_health_checks_total            | Counter               | Number of proxy health checks                                      |
| proxied_connections                  | Gauge                 | Number of proxy connects                                           |
| proxy_passthroughs_to_client_total   | Counter               | Number of successful proxy passthroughs from server to client      |
| proxy_passthroughs_to_server_total   | Counter               | Number of successful proxy passthroughs from client to server      |
| proxy_passthrough_terminations_total | Counter               | Number of proxy passthrough terminations by plugins                |
| api_requests_total                   | Counter (with labels) | Number of API requests                                             |
| api_requests_errors_total            | Counter (with labels) | Number of API request errors                                       |

## Example configuration

```yaml
metrics:
  default:
    enabled: True
    address: localhost:9090
    path: /metrics
    readHeaderTimeout: 10s
    timeout: 10s
    certFile: ""
    keyFile: ""
```
