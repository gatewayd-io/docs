---
last_modified_date: 2024-10-28 17:19:33
layout: default
title: gatewayd-plugin-sql-ids-ips
description: GatewayD plugin for SQL injection detection and prevention.
nav_order: 2
parent: Plugins
---

# gatewayd-plugin-sql-ids-ips

The `gatewayd-plugin-sql-ids-ips` is a security-focused GatewayD plugin designed to detect and prevent SQL injection attacks. By utilizing advanced detection methods, it provides robust protection against malicious SQL queries and offers configurable response mechanisms to safeguard databases effectively.

## How It Works

1. **Injection Detection**: The plugin analyzes incoming SQL queries from clients, looking for patterns that match known SQL injection attacks.
2. **Blocking Malicious Queries**: If a query is deemed malicious, the plugin blocks it, either returning an error or an empty response to the client.
3. **Audit Logging**: All detections are logged with details, including the original query and a prediction score.
4. **Prometheus Metrics**: Metrics are generated for monitoring detection events, enabling administrators to track potential threats and plugin performance.

## Features

- **Advanced Detection Methods**:
  - **Signature-Based Detection**: Uses a trained model with Tensorflow and Keras to match queries against known SQL injection patterns.
  - **Syntax-Based Detection**: Examines SQL syntax to detect anomalies using `libinjection`.
- **Defense Mechanisms**:
  - **MITRE ATT&CK T1190**: Detects and prevents SQL injection attacks under the MITRE framework.
  - **OWASP Top 10:2021 A3 Compliance**: Addresses injection vulnerabilities as per OWASP standards.
  - **CAPEC-66 and CWE-89 Compliance**: Adheres to Common Weakness Enumeration guidelines.
- **Response Customization**: Configure responses to SQL injection attempts, choosing between an error or empty response.
- **Prometheus Metrics Integration**: Captures detection metrics for insights into plugin performance.
- **Logging**: Detailed logs are maintained for each detected injection attempt, including a prediction confidence score.
- **Configurable via Environment Variables**: Control plugin behavior and thresholds easily.

## DeepSQLi

The plugin must be used in conjunction with DeepSQLi, a deep-learning model for SQL injection detection. DeepSQLi is available as a separate service and must be started before the plugin. For more information, refer to the [DeepSQLi documentation](https://github.com/gatewayd-io/DeepSQLi).

## Installation

### Automatic Installation

Install the latest version of the plugin from [GitHub releases](https://github.com/gatewayd-io/gatewayd-plugin-sql-ids-ips/releases):

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-sql-ids-ips@latest
```

### Manual Installation

1. Download and install the latest release by copying the binary to a directory accessible to GatewayD.
2. Update the configuration file in `gatewayd_plugins.yaml`.

After installation, start GatewayD and test the plugin by sending queries to verify SQL injection detection.

## Configuration

The plugin can be configured using environment variables and command-line arguments. Below is a sample configuration:

```yaml
plugins:
  - name: gatewayd-plugin-sql-ids-ips
    enabled: True
    localPath: ../gatewayd-plugin-sql-ids-ips/gatewayd-plugin-sql-ids-ips
    url: github.com/gatewayd-io/gatewayd-plugin-sql-ids-ips@latest
    args: ["--log-level", "info"]
    env:
      - MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN
      - MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872
      - METRICS_ENABLED=True
      - METRICS_UNIX_DOMAIN_SOCKET=/tmp/gatewayd-plugin-sql-ids-ips.sock
      - METRICS_PATH=/metrics
      - PREDICTION_API_ADDRESS=http://localhost:8000
      - THRESHOLD=0.8
      - ENABLE_LIBINJECTION=True
      - LIBINJECTION_PERMISSIVE_MODE=True
      - RESPONSE_TYPE=error
      - ERROR_SEVERITY=EXCEPTION
      - ERROR_NUMBER=42000
      - ERROR_MESSAGE=SQL injection detected
      - ERROR_DETAIL=Back off, you're not welcome here.
      - LOG_LEVEL=error
      - SENTRY_DSN=https://379ef59ea0c55742957b06c94bc496e1@o4504550475038720.ingest.us.sentry.io/4507282732810240
    checksum: dee4aa014a722e1865d91744a4fd310772152467d9c6ab4ba17fd9dd40d3f724
```

## Environment Variables

| Name                           | Description                                                                                   | Default                                                                                                           |
| ------------------------------ | --------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| `MAGIC_COOKIE_KEY`             | The key for the magic cookie.                                                                 | `GATEWAYD_PLUGIN`                                                                                                 |
| `MAGIC_COOKIE_VALUE`           | The value for the magic cookie.                                                               | `5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872`                                                |
| `METRICS_ENABLED`              | Whether to enable metrics.                                                                    | `True`                                                                                                            |
| `METRICS_UNIX_DOMAIN_SOCKET`   | The path to the Unix domain socket for exposing metrics. This must be accessible to GatewayD. | `/tmp/gatewayd-plugin-sql-ids-ips.sock`                                                                           |
| `METRICS_PATH`                 | The path for exposing metrics.                                                                | `/metrics`                                                                                                        |
| `PREDICTION_API_ADDRESS`       | The address for the prediction API server.                                                    | `http://localhost:8000`                                                                                           |
| `THRESHOLD`                    | The threshold for the prediction confidence score.                                            | `0.8`                                                                                                             |
| `ENABLE_LIBINJECTION`          | Whether to enable syntax-based detection using `libinjection`.                                | `True`                                                                                                            |
| `LIBINJECTION_PERMISSIVE_MODE` | Whether to enable permissive mode for `libinjection`.                                         | `True`                                                                                                            |
| `RESPONSE_TYPE`                | The response type for SQL injection attempts. Choose between `error` or `empty`.              | `error`                                                                                                           |
| `ERROR_SEVERITY`               | The severity level for the error response.                                                    | `EXCEPTION`. See [this](https://www.postgresql.org/docs/current/protocol-error-fields.html) for more information. |
| `ERROR_NUMBER`                 | The error number for the error response.                                                      | `42000`. See [this](https://www.postgresql.org/docs/current/errcodes-appendix.html) for more information.         |
| `ERROR_MESSAGE`                | The error message for the error response.                                                     | `SQL injection detected`                                                                                          |
| `ERROR_DETAIL`                 | The error detail for the error response.                                                      | `Back off, you're not welcome here.`                                                                              |
| `LOG_LEVEL`                    | The log level for the plugin.                                                                 | `error`                                                                                                           |
| `SENTRY_DSN`                   | Sentry DSN. Set to empty string to disable Sentry.                                            | `https://379ef59ea0c55742957b06c94bc496e1@o4504550475038720.ingest.us.sentry.io/4507282732810240`                 |

### Command-line arguments

| Name          | Description    | Default |
| ------------- | -------------- | ------- |
| `--log-level` | The log level. | `info`  |

## Build for testing

To build the plugin for development and testing, run the following command in the project's root directory after cloning the repository.

```bash
git clone git@github.com:gatewayd-io/gatewayd-plugin-sql-ids-ips.git
cd gatewayd-plugin-sql-ids-ips
make build-dev
```

Running the above commands clones the repository, changes the current directory and runs the `go mod tidy` and `go build` commands to compile and generate the plugin binary.
