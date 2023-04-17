# CLI

GatewayD is a CLI application that runs on Linux-based distributions and macOS. The application has four subcommands that are explained below:

| Subcommand   | Description                                                           | Flags/Example                                                                                                                                                |
| ------------ | --------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `completion` | generates the autocompletion script for the specified shell           | - `bash`<br/>- `fish`<br/>- `powershell`<br/>- `zsh`                                                                                                         |
| `help`       | shows help about any subcommand                                       | -                                                                                                                                                            |
| `run`        | runs an instance of `gatewayd` with the specified configuration files | - `-c`, `--config`: global config file (default `"./gatewayd.yaml"`)<br/>- `-p`, `--plugin-config`: plugin config file (default `"./gatewayd_plugins.yaml"`) |
| `version`    | shows version information                                             | `GatewayD v0.6.0 (2023-03-12T22:22:55+0000/ae469dc, go1.20.1, linux/amd64)`                                                                                  |

There are also global flags that can enable or disable certain features:

| Flag                     | Description                                                               |
| ------------------------ | ------------------------------------------------------------------------- |
| `--tracing`              | Enable tracing with OpenTelemetry via gRPC                                |
| `--collector-url string` | Collector URL of OpenTelemetry gRPC endpoint (default `"localhost:4317"`) |
| `--sentry`               | Enable Sentry for error reporting (default `true`)                        |
| `--dev`                  | Enable development mode for plugin development                            |
| `--usage-report`         | Enable usage report (default `true`)                                      |

> **🗒️ Note**
>
> Please visit the [telemetry and usage report](../07-miscellaneous/telemetry-and-usage-report.md) page for more information on which pieces of data are collected by the service.
