---
last_modified_date: 2024-03-07 22:33:34
layout: default
title: Plugins configuration
description: GatewayD plugins configuration
nav_order: 2
parent: Plugins Configuration
grand_parent: Using GatewayD
---

# Plugins configuration

The plugin configuration is a list of plugins to load. Each plugin has its own configuration section. The configuration section is named after the plugin name. For example, the configuration section for the cache plugin is named `gatewayd-plugin-cache`.

The order in which the plugin appears in the `plugins` group determines its priority. The first plugin in the list has the highest priority and is called first and the last plugin has the lowest priority and is called last. The output of the plugin is passed to the next plugin in the list.

Each plugin is defined by a name, a path to the plugin's executable, and a list of arguments to pass to the plugin. The plugin's executable is expected to be a plugin that implements the [GatewayD plugin
interface](https://github.com/gatewayd-io/gatewayd-plugin-sdk/blob/main/plugin/v1/plugin.proto) via the [GatewayD plugin SDK](https://github.com/gatewayd-io/gatewayd-plugin-sdk) using gRPC. The SDK is built for Go plugins, but other languages can be used as long as they implement the GatewayD plugin interface.

## Configuration parameters

| Name      | Type           | Default value | Possible values  | Description                                                        |
| --------- | -------------- | ------------- | ---------------- | ------------------------------------------------------------------ |
| name      | string         | -             | -                | The name of the plugin.                                            |
| enabled   | boolean        | True          | True, False      | Enables/disables the plugin.                                       |
| localPath | string         | -             | Valid file paths | The path to the plugin's executable.                               |
| url       | string         | -             | -                | The GitHub URL of the plugin plus the version tag (or latest).     |
| args      | list of string | -             | -                | The list of arguments to pass to the plugin's command, aka. flags. |
| env       | list           | -             | -                | The list of environment variables to pass to the plugin.           |
| checksum  | string         | -             | -                | The SHA256 checksum of the plugin's executable.                    |

The `MAGIC_COOKIE_KEY` and `MAGIC_COOKIE_VALUE` environment variables are used to verify the identity of the plugin and are required for Go plugins only. Their values are constant. The `env` field is optional if the `MAGIC_COOKIE_KEY` and `MAGIC_COOKIE_VALUE` are hardcoded in the plugin's executable.

## Example configuration

```yaml
plugins:
  - name: gatewayd-plugin-cache
    enabled: True
    localPath: ../gatewayd-plugin-cache/gatewayd-plugin-cache
    url: github.com/gatewayd-io/gatewayd-plugin-cache@latest
    args: ["--log-level", "debug"]
    env:
      - MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN
      - MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872
      - REDIS_URL=redis://localhost:6379/0
      - EXPIRY=1h
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
