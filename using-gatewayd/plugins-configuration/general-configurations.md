---
last_modified_date: 2024-12-27 23:54:39
layout: default
title: General configurations
description: General configurations for plugins
nav_order: 1
parent: Plugins Configuration
grand_parent: Using GatewayD
---

# General configurations

## Configuration parameters

| Name                | Type    | Default value    | Possible values              | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| ------------------- | ------- | ---------------- | ---------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| enableMetricsMerger | boolean | True             | True, False                  | If enabled, GatewayD will merge the Prometheus metrics of all plugins over Unix domain socket. The metrics are merged and exposed via the GatewayD [metrics](/global-configuration/metrics) endpoint via HTTP.                                                                                                                                                                                                                                                                                                             |
| metricsMergerPeriod | string  | 5s               | Valid duration strings       | The metrics merger period controls how often the metrics merger should collect and merge metrics from plugins.                                                                                                                                                                                                                                                                                                                                                                                                             |
| healthCheckPeriod   | string  | 5s               | Valid duration strings       | The health check period controls how often the health check should be performed. The health check is performed by pinging each plugin. Unhealthy plugins are removed.                                                                                                                                                                                                                                                                                                                                                      |
| reloadOnCrash       | boolean | True             | True, False                  | If enabled, GatewayD will reload the plugin if it crashes. The crash is detected by the health check.                                                                                                                                                                                                                                                                                                                                                                                                                      |
| timeout             | string  | 30s              | Valid duration strings       | The timeout controls how long to wait for a plugin to respond to a request before timing out.                                                                                                                                                                                                                                                                                                                                                                                                                              |
| startTimeout        | string  | 1m               | Valid duration strings       | The start timeout controls how long to wait for a plugin to start before timing out.                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| policyTimeout       | string  | 30s              | Valid duration strings       | The policy timeout controls how long to wait for a policy to evaluate before timing out.                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| policies            | array   | []               | An array of objects          | The policies are a set of rules that are evaluated against the signals to determine whether the actions should be executed.                                                                                                                                                                                                                                                                                                                                                                                                |
| actionTimeout       | string  | 30s              | Valid duration strings       | The actionTimeout will set a default timeout for all the actions that are going to be executed. Action specific timeout has priority over this value. Set to `0` to remove default action timeout.                                                                                                                                                                                                                                                                                                                         |
| actionRedis         | object  |                  |                              | The actionRedis provides a Redis connection to be used by Act system to publish async actions to. If not given, or not enabled, async actions will run in a background goroutine.                                                                                                                                                                                                                                                                                                                                          |
| actionRedis.enabled | boolean | False            | True, False                  | If enabled, will use configuration to connect to a Redis Pub/Sub channel and publish async actions data.                                                                                                                                                                                                                                                                                                                                                                                                                   |
| actionRedis.address | string  | localhost:6379   | Valid Redis connection url   | URL used to connect to async action Redis.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 |
| actionRedis.channel | string  | gatewayd-actions | Any valid Redis channel name | Name of the channel that async actions will be published to.                                                                                                                                                                                                                                                                                                                                                                                                                                                               |

## Example configuration

```yaml
enableMetricsMerger: True
metricsMergerPeriod: 5s
healthCheckPeriod: 5s
reloadOnCrash: True
timeout: 30s
startTimeout: 1m
policyTimeout: 30s
actionTimeout: 30s
policies:
  name: terminate
  policy: "Signal.terminate == true && Policy.terminate == 'stop'"
  metadata:
    terminate: "stop" # Change this to "continue" to continue the execution
actionRedis:
  enabled: True
  address: localhost:6379
  channel: gatewayd-actions
```
