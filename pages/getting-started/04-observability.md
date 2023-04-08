# Observability

Observability is a first-class citizen of GatewayD by generating logs, metrics and traces. This ranges from support for multiple loggers and logging to multiple outputs to performance metrics and traces of almost everything that happens internally. The configuration parameters for logging and metrics are available in the `gatewayd.yaml` file. Tracing can be enabled via the `--tracing` flag on the command line.

## Logs

GatewayD supports multiple loggers. Each logger can send logs to multiple outputs, including console, stdout/stderr, files and (r)syslog.

![Logs in console](assets/console-log.png)

## Metrics

Metrics are exposed from GatewayD and the plugins in Prometheus format. GatewayD collects, relabels and merges Prometheus metrics from all the plugins and exposes them over `http://localhost:2112/metrics` by default, which is customizable. List of built-in metrics are available [here](https://github.com/gatewayd-io/gatewayd/blob/main/metrics/builtins.go).

![Metrics](assets/prometheus.png)

## Traces

Tracing can be enabled from the command line. Once enabled, it'll send traces in OpenTelemetry format via gRPC to supported backends, such as [Jaeger](https://www.jaegertracing.io/) and [Grafana Tempo](https://grafana.com/oss/tempo/).

![Traces](assets/jaeger.png)
