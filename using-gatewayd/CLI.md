---
last_modified_date: 2023-06-10 00:56:10 +0200
layout: default
title: CLI
description: GatewayD is a CLI application that runs on Windows, Linux-based distributions and macOS.
nav_order: 4
parent: Using GatewayD
---

# CLI

GatewayD is a CLI application that runs on Windows, Linux-based distributions and macOS. The application has many subcommands that are explained below:

| Subcommand       | Description                                                           | Flags/Example                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| ---------------- | --------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `completion`     | generates the autocompletion script for the specified shell           | - `bash`<br/>- `fish`<br/>- `powershell`<br/>- `zsh`                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| `config`         | manages GatewayD global configuration                                 |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `config init`    | generates a global configuration file                                 | - `-c`, `--config` global config file (default "gatewayd.yaml")<br/>- `-f`, `--force`: overwrites the existing config file<br/>- `--sentry`: Enable Sentry for error reporting (default `true`)                                                                                                                                                                                                                                                                                                                                  |
| `config lint`    | validates global configuration file                                   | - `-c`, `--config` global config file (default "gatewayd.yaml") <br/>- `--sentry`: Enable Sentry for error reporting (default `true`)                                                                                                                                                                                                                                                                                                                                                                                            |
| `help`           | shows help about any subcommand                                       | The `-h` or `--help` flag can be used to get more information about a specific subcommand.                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| `plugin`         | manages GatewayD plugins and their configurations                     |                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `plugin init`    | generates a plugins configuration file                                | - `-p`, `--plugin-config`: plugins config file (default "gatewayd_plugins.yaml")<br/>- `-f`, `--force`: overwrites the existing config file<br/>- `--sentry`: Enable Sentry for error reporting (default `true`)                                                                                                                                                                                                                                                                                                                 |
| `plugin install` | installs a plugin from GitHub                                         | - `-p`, `--plugin-config`: plugins config file (default "gatewayd_plugins.yaml")<br/>- `-o`, `--output-dir`: output directory of the plugin, where the plugin is extracted (default "./plugins")<br/>- `--pull-only`: only pull the plugin, don't install it<br/>- `--sentry`: Enable Sentry for error reporting (default `true`)                                                                                                                                                                                                |
| `plugin lint`    | validates plugins configuration file                                  | - `-p`, `--plugin-config`: plugins config file (default "gatewayd_plugins.yaml")<br/>- `--sentry`: Enable Sentry for error reporting (default `true`)                                                                                                                                                                                                                                                                                                                                                                            |
| `run`            | runs an instance of `gatewayd` with the specified configuration files | - `-c`, `--config`: global config file (default `"gatewayd.yaml"`)<br/>- `-p`, `--plugin-config`: plugin config file (default `"gatewayd_plugins.yaml"`)<br/>- `--tracing`: Enable tracing with OpenTelemetry via gRPC<br/>- `--collector-url string`: Collector URL of OpenTelemetry gRPC endpoint (default `"localhost:4317"`)<br/>- `--sentry`: Enable Sentry for error reporting (default `true`)<br/>- `--dev`: Enable development mode for plugin development<br/>- `--usage-report`: Enable usage report (default `true`) |
| `version`        | shows version information                                             | `GatewayD v0.6.0 (2023-03-12T22:22:55+0000/ae469dc, go1.20.1, linux/amd64)`                                                                                                                                                                                                                                                                                                                                                                                                                                                      |

{: .note }
> Please visit the [telemetry and usage report](../miscellaneous/telemetry-and-usage-report) page for more information on which pieces of data are collected by the service.