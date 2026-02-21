---
last_modified_date: 2026-02-21 21:42:00
layout: default
title: Troubleshooting
description: Common issues and solutions when running GatewayD.
nav_order: 3
parent: Miscellaneous
---

# Troubleshooting

This page covers common issues you may encounter when running GatewayD and how to resolve them.

## GatewayD won't start

### Port already in use

**Symptom**: GatewayD exits with an error like `bind: address already in use`.

**Solution**: Another process is using the port. Check which process is using it:

```bash
lsof -i :15432
```

Either stop the conflicting process or change the GatewayD listening port in the [server configuration](/using-gatewayd/global-configuration/servers).

### Configuration file not found

**Symptom**: Error mentioning `gatewayd.yaml` or `gatewayd_plugins.yaml` not found.

**Solution**: Generate default configuration files using the CLI:

```bash
gatewayd config init
```

Or specify the path explicitly:

```bash
gatewayd run --config /path/to/gatewayd.yaml --plugin-config /path/to/gatewayd_plugins.yaml
```

### Invalid configuration

**Symptom**: GatewayD exits with a configuration validation error.

**Solution**: Lint your configuration files:

```bash
gatewayd config lint --config /path/to/gatewayd.yaml
gatewayd config lint --plugin-config /path/to/gatewayd_plugins.yaml
```

## Connection issues

### Cannot connect to the backend database

**Symptom**: Database clients can connect to GatewayD but queries fail or time out. Logs show connection errors to the backend.

**Solution**:

1. Verify the backend database address in the [clients configuration](/using-gatewayd/global-configuration/clients).
2. Ensure the backend database is reachable from the GatewayD host:

   ```bash
   pg_isready -h <backend-host> -p <backend-port>
   ```

3. Check that the database credentials in the configuration are correct.
4. If using TLS, verify certificate paths and permissions.

### Connection pool exhaustion

**Symptom**: New client connections are refused or delayed. Logs mention pool exhaustion.

**Solution**:

1. Increase the pool size in the [pools configuration](/using-gatewayd/global-configuration/pools).
2. Check if client connections are being properly closed by the application.
3. Monitor connection metrics via Prometheus to understand usage patterns.

### Stale connections

**Symptom**: Queries intermittently fail with connection reset or broken pipe errors.

**Solution**: Stale connections occur when the backend database closes idle connections. Enable [connection health checking](/using-gatewayd/proxies#connection-health-check) to periodically verify backend connections.

## Plugin issues

### Plugin fails to start

**Symptom**: GatewayD logs show errors about a plugin failing to start.

**Solution**:

1. Verify the plugin binary path in `gatewayd_plugins.yaml`.
2. Check that the plugin binary has execute permissions.
3. Ensure the plugin's required environment variables are set.
4. Increase the `startTimeout` in the [general plugin configuration](/using-gatewayd/plugins-configuration/general-configurations) if the plugin needs more time to initialize.

### Plugin crashes and restarts

**Symptom**: Logs show a plugin being restarted repeatedly.

**Solution**:

1. Check plugin-specific logs for error details.
2. Verify that the plugin's dependencies are available (e.g., Redis for the cache plugin).
3. Set `reloadOnCrash: False` in the [general plugin configuration](/using-gatewayd/plugins-configuration/general-configurations) to prevent restart loops while debugging.

### Checksum verification failure

**Symptom**: GatewayD refuses to load a plugin due to checksum mismatch.

**Solution**: Regenerate the checksum for the plugin binary and update it in `gatewayd_plugins.yaml`. See [checksum verification](/using-plugins/plugins#checksum-verification) for details.

## Raft clustering issues

### Node fails to join the cluster

**Symptom**: A non-bootstrap node logs errors about failing to join within the timeout (5 minutes).

**Solution**:

1. Verify that the bootstrap node is running and reachable.
2. Check that `raft.address` and `raft.grpcAddress` are accessible from the joining node.
3. Ensure `nodeId` values are unique across all nodes.
4. Check firewall rules allow traffic on the configured Raft and gRPC ports.

### Split-brain or leader election issues

**Symptom**: Nodes report conflicting leaders or frequent leader elections.

**Solution**:

1. Ensure network connectivity between all nodes is stable and low-latency.
2. Use an odd number of nodes (3 or 5) for proper quorum.
3. Monitor `gatewayd_raft_last_contact_seconds` to identify network issues.

## Performance

### High latency

**Solution**:

1. Enable debug logging temporarily to identify bottlenecks:

   ```bash
   GATEWAYD_LOGGERS_DEFAULT_LEVEL=debug gatewayd run
   ```

2. Check Prometheus metrics for connection pool utilization and proxy latency.
3. In multi-node clusters, Raft consensus adds latency to every load balancer decision. Consider whether single-node deployment is sufficient for your use case.

### High memory usage

**Solution**:

1. Review pool sizes -- each backend connection consumes memory.
2. Check plugin memory usage, especially plugins that buffer data (e.g., the cache plugin's Redis connection count).
3. Monitor metrics to correlate memory usage with connection count.

## Debugging

### Enable debug logging

Set the log level to `debug` for verbose output:

```yaml
loggers:
  default:
    level: debug
```

Or via an environment variable:

```bash
GATEWAYD_LOGGERS_DEFAULT_LEVEL=debug gatewayd run
```

### Enable tracing

Send OpenTelemetry traces to a supported backend:

```bash
gatewayd run --tracing
```

Traces are sent via gRPC to the configured collector. See [observability](/using-gatewayd/observability#traces) for details.

### Check API health

The HTTP API provides a health check endpoint:

```bash
curl http://localhost:18080/healthz
```
