---
last_modified_date: 2026-02-21 21:42:00
layout: default
title: Deployment
description: Deploy GatewayD in production using Docker, Docker Compose, Linux packages, or pre-built binaries.
nav_order: 14
parent: Using GatewayD
---

# Deployment

GatewayD can be deployed using Docker images, Docker Compose, Linux packages (.deb/.rpm), or pre-built binaries. This page covers each deployment method.

## Docker

Official multi-platform Docker images (linux/amd64, linux/arm64) are published to [Docker Hub](https://hub.docker.com/r/gatewaydio/gatewayd) and [GitHub Container Registry](https://github.com/gatewayd-io/gatewayd/pkgs/container/gatewayd).

### Quick start

```bash
docker run -d \
  --name gatewayd \
  -p 15432:15432 \
  -p 18080:18080 \
  gatewaydio/gatewayd:latest \
  run --config /etc/gatewayd.yaml --plugin-config /etc/gatewayd_plugins.yaml
```

The image ships with default configuration files at `/etc/gatewayd.yaml` and `/etc/gatewayd_plugins.yaml`. Mount your own to customize:

```bash
docker run -d \
  --name gatewayd \
  -v $(pwd)/gatewayd.yaml:/etc/gatewayd.yaml \
  -v $(pwd)/gatewayd_plugins.yaml:/etc/gatewayd_plugins.yaml \
  -p 15432:15432 \
  -p 18080:18080 \
  gatewaydio/gatewayd:latest \
  run --config /etc/gatewayd.yaml --plugin-config /etc/gatewayd_plugins.yaml
```

### Exposed ports

| Port  | Protocol | Description                                      |
| ----- | -------- | ------------------------------------------------ |
| 15432 | TCP      | PostgreSQL proxy (database clients connect here) |
| 18080 | HTTP     | HTTP API gateway                                 |
| 19090 | gRPC     | gRPC API with reflection                         |
| 9090  | HTTP     | Prometheus metrics                               |

## Docker Compose

### Single-node with observability stack

The [GatewayD repository](https://github.com/gatewayd-io/gatewayd) includes a `docker-compose.yaml` that sets up a complete environment with:

- **GatewayD** proxying to PostgreSQL
- **Write and read PostgreSQL** instances
- **Redis** for the cache plugin
- **Prometheus**, **Grafana**, and **Tempo** for observability

```bash
git clone https://github.com/gatewayd-io/gatewayd.git
cd gatewayd
docker compose up -d
```

Key endpoints after startup:

| Service                   | URL                      |
| ------------------------- | ------------------------ |
| GatewayD PostgreSQL proxy | `localhost:15432`        |
| GatewayD HTTP API         | `http://localhost:18080` |
| Prometheus                | `http://localhost:9090`  |
| Grafana                   | `http://localhost:3000`  |

### Three-node Raft cluster

A `docker-compose-raft.yaml` file is also provided for a high-availability deployment with three GatewayD nodes using the [Raft consensus protocol](/using-gatewayd/clustering):

```bash
docker compose -f docker-compose-raft.yaml up -d
```

Each node uses staggered ports (e.g., 15432, 15433, 15434 for the PostgreSQL proxy) and separate Raft data volumes. The bootstrap node is `gatewayd-1`; nodes 2 and 3 join automatically.

## Environment variables

All configuration values in `gatewayd.yaml` can be overridden using environment variables with the `GATEWAYD_` prefix. The naming convention maps to the YAML hierarchy:

```
GATEWAYD_<SECTION>_<GROUP>_<KEY>
```

For example:

| Variable                                  | Config path                      | Purpose                |
| ----------------------------------------- | -------------------------------- | ---------------------- |
| `GATEWAYD_CLIENTS_DEFAULT_WRITES_ADDRESS` | `clients.default.writes.address` | Write database address |
| `GATEWAYD_CLIENTS_DEFAULT_READS_ADDRESS`  | `clients.default.reads.address`  | Read database address  |
| `GATEWAYD_LOGGERS_DEFAULT_LEVEL`          | `loggers.default.level`          | Log level              |

Environment variables take precedence over values in configuration files.

## Pre-built binaries

Pre-built binaries are available for every release on the [GitHub Releases](https://github.com/gatewayd-io/gatewayd/releases) page.

### Supported platforms

| OS      | Architecture                         |
| ------- | ------------------------------------ |
| Linux   | amd64, arm64                         |
| macOS   | amd64 (Intel), arm64 (Apple Silicon) |
| Windows | amd64, arm64                         |

### Installation from binary

```bash
# Download the latest release (Linux amd64 example)
curl -L https://github.com/gatewayd-io/gatewayd/releases/latest/download/gatewayd-linux-amd64.tar.gz \
  -o gatewayd.tar.gz

# Extract
tar xzf gatewayd.tar.gz

# Move to PATH
sudo mv gatewayd /usr/local/bin/

# Generate default config files
gatewayd config init
```

## Linux packages

GatewayD is packaged as `.deb` (Debian/Ubuntu) and `.rpm` (RHEL/Fedora/CentOS) for both amd64 and arm64 architectures. Packages are available on the [GitHub Releases](https://github.com/gatewayd-io/gatewayd/releases) page.

### Installation paths

| File          | Path                         |
| ------------- | ---------------------------- |
| Binary        | `/usr/bin/gatewayd`          |
| Global config | `/etc/gatewayd.yaml`         |
| Plugin config | `/etc/gatewayd_plugins.yaml` |

Configuration files are marked as `config(noreplace)`, so they are preserved across package upgrades.

### Debian/Ubuntu

```bash
sudo dpkg -i gatewayd_<version>_amd64.deb
```

### RHEL/Fedora

```bash
sudo rpm -i gatewayd-<version>.x86_64.rpm
```

## Production considerations

### Health checks

The HTTP API exposes a health check endpoint at `/healthz` that can be used by load balancers and container orchestrators.

### Observability

GatewayD provides built-in support for [logs, metrics, and traces](/using-gatewayd/observability). Pre-configured Prometheus, Grafana, and Tempo configurations are included in the `observability-configs/` directory of the repository.

### TLS

TLS can be configured for both the client-facing server and the backend client connections. See the [servers](/using-gatewayd/global-configuration/servers) and [clients](/using-gatewayd/global-configuration/clients) configuration pages. For Raft cluster TLS, see the [clustering](/using-gatewayd/clustering) page.

### High availability

For high availability, deploy a [Raft cluster](/using-gatewayd/clustering) with at least three nodes behind a TCP load balancer. Each node maintains synchronized load balancer state.

### Security

- Run GatewayD as a non-root user in production.
- Enable TLS for all client-facing and backend connections.
- Enable Raft TLS (`isSecure: True`) for inter-node communication in multi-node deployments.
- Use the [gatewayd-plugin-auth](/plugins/gatewayd-plugin-auth) plugin to add authentication.
- Restrict access to the API ports (18080, 19090) to trusted networks.
