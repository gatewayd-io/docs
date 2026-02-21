---
last_modified_date: 2026-02-21 21:42:00
layout: default
title: Clustering
description: GatewayD supports multi-node clustering via the Raft consensus protocol to replicate load balancer state across nodes.
nav_order: 13
parent: Using GatewayD
---

# Clustering

GatewayD supports multi-node clustering using the [Raft consensus protocol](https://raft.github.io/). When multiple GatewayD instances form a cluster, Raft ensures that load balancer state is replicated across all nodes so that every node makes consistent routing decisions.

## What gets replicated

Raft replicates **load balancer state** across the cluster. This includes:

| Replicated state             | Description                                                                                                                       |
| ---------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| Consistent hash mappings     | Maps a hash (derived from client IP and configuration group) to a proxy, ensuring the same client always reaches the same backend |
| Round robin index            | Tracks which proxy comes next per server group so all nodes agree on the rotation                                                 |
| Weighted round robin weights | Tracks current and effective weights per proxy per group for correct weighted distribution                                        |
| Peer membership              | Tracks known peers (ID, Raft address, gRPC address) for cluster coordination                                                      |

Every time a load balancer decision is made, the state change goes through Raft consensus before returning a result. On follower nodes, writes are forwarded to the leader via gRPC.

## Configuration parameters

The Raft configuration is a top-level section in `gatewayd.yaml`:

| Parameter   | Type    | Default           | Description                                                                               |
| ----------- | ------- | ----------------- | ----------------------------------------------------------------------------------------- |
| address     | string  | `127.0.0.1:2222`  | TCP address for Raft consensus protocol communication between nodes                       |
| nodeId      | string  | `node1`           | Unique identifier for this node in the cluster. Falls back to hostname if empty           |
| isBootstrap | boolean | `True`            | Whether this node bootstraps a new cluster. Exactly one node must have this set to `True` |
| isSecure    | boolean | `False`           | Enables TLS for the internal gRPC communication between Raft nodes                        |
| certFile    | string  | `""`              | Path to TLS certificate file (PEM). Required when `isSecure` is `True`                    |
| keyFile     | string  | `""`              | Path to TLS private key file (PEM). Required when `isSecure` is `True`                    |
| grpcAddress | string  | `127.0.0.1:50051` | Address for the Raft-internal gRPC server used for inter-node RPCs                        |
| directory   | string  | `raft`            | Directory where Raft data is persisted. Actual path is `<directory>/<nodeId>/`            |
| peers       | array   | `[]`              | List of known peers to connect to when joining an existing cluster                        |

Each entry in `peers` has three fields:

| Field       | Type   | Description                                |
| ----------- | ------ | ------------------------------------------ |
| id          | string | The peer's node ID                         |
| address     | string | The peer's Raft protocol address           |
| grpcAddress | string | The peer's gRPC address for inter-node RPC |

## Setting up a cluster

### Single node (default)

The default `gatewayd.yaml` runs a single bootstrap node. No special configuration is needed:

```yaml
raft:
  address: 127.0.0.1:2222
  nodeId: node1
  isBootstrap: True
  grpcAddress: 127.0.0.1:50051
  peers: []
```

### Multi-node cluster

To run a three-node cluster, configure each node as follows.

**Node 1** (bootstrap node):

```yaml
raft:
  address: 192.168.1.10:2222
  nodeId: node1
  isBootstrap: True
  grpcAddress: 192.168.1.10:50051
  peers:
    - id: node2
      address: 192.168.1.11:2222
      grpcAddress: 192.168.1.11:50051
    - id: node3
      address: 192.168.1.12:2222
      grpcAddress: 192.168.1.12:50051
```

**Node 2** (joining node):

```yaml
raft:
  address: 192.168.1.11:2222
  nodeId: node2
  isBootstrap: False
  grpcAddress: 192.168.1.11:50051
  peers:
    - id: node1
      address: 192.168.1.10:2222
      grpcAddress: 192.168.1.10:50051
```

**Node 3** (joining node):

```yaml
raft:
  address: 192.168.1.12:2222
  nodeId: node3
  isBootstrap: False
  grpcAddress: 192.168.1.12:50051
  peers:
    - id: node1
      address: 192.168.1.10:2222
      grpcAddress: 192.168.1.10:50051
```

{: .note }
> Exactly one node must have `isBootstrap: True`. Non-bootstrap nodes join the cluster by sending `AddPeer` gRPC calls to their configured peers, retrying every 5 seconds with a total timeout of 5 minutes.

### Using Docker Compose

A ready-made `docker-compose-raft.yaml` is available in the [GatewayD repository](https://github.com/gatewayd-io/gatewayd) that sets up a three-node Raft cluster with PostgreSQL backends and observability tooling. See the [deployment](/using-gatewayd/deployment) page for details.

## Peer discovery and management

Peers must be explicitly configured in `gatewayd.yaml` or added at runtime via the API. There is no automatic DNS-based or multicast discovery.

A background **peer synchronizer** runs every 30 seconds, reconciling the Raft membership with known peers. If a peer exists in the Raft configuration but is missing from the local state, other peers are queried via `GetPeerInfo` RPC.

### Adding and removing peers at runtime

Peers can be managed via the GatewayD REST API:

- **Add peer**: `POST /v1/raft/add-peer` with `peer_id`, `address`, and `grpc_address`
- **Remove peer**: `POST /v1/raft/remove-peer` with `peer_id`
- **List peers**: Returns the peer list with status (Leader, Follower, NonVoter, Unknown)

## Storage

Raft data is persisted using BoltDB under `<directory>/<nodeId>/`:

- `raft-log.db` -- Raft log store
- `raft-stable.db` -- Stable store (term, vote, etc.)
- File-based snapshots (up to 3 retained)

Ensure the configured directory is writable by the GatewayD process.

## Metrics

The following Prometheus metrics are exposed for Raft:

| Metric                               | Type    | Description                                 |
| ------------------------------------ | ------- | ------------------------------------------- |
| `gatewayd_raft_health_status`        | Gauge   | 1 if healthy, 0 if unhealthy                |
| `gatewayd_raft_leader_status`        | Gauge   | 1 if leader, 0 if follower                  |
| `gatewayd_raft_last_contact_seconds` | Gauge   | Milliseconds since last contact with leader |
| `gatewayd_raft_peer_additions_total` | Counter | Total peer additions                        |
| `gatewayd_raft_peer_removals_total`  | Counter | Total peer removals                         |

All metrics include a `node_id` label.

## Environment variables

Raft configuration can be overridden with environment variables using the `GATEWAYD_` prefix:

| Variable                    | Maps to                   |
| --------------------------- | ------------------------- |
| `GATEWAYD_RAFT_ADDRESS`     | `raft.address`            |
| `GATEWAYD_RAFT_NODEID`      | `raft.nodeId`             |
| `GATEWAYD_RAFT_ISBOOTSTRAP` | `raft.isBootstrap`        |
| `GATEWAYD_RAFT_GRPCADDRESS` | `raft.grpcAddress`        |
| `GATEWAYD_RAFT_PEERS`       | `raft.peers` (JSON array) |

## Limitations

- **Always enabled**: The Raft subsystem starts with every `gatewayd run`. A single-node cluster is the default when no peers are configured.
- **No automatic discovery**: Peers must be explicitly configured or added via the API.
- **Consensus latency**: Every load balancer decision goes through a Raft consensus round-trip. In multi-node clusters, follower nodes forward writes to the leader, which adds latency.
- **Hardcoded timeouts**: Internal timeouts (leader election: 3s, apply: 2s, transport: 10s, cluster join: 5m) are not configurable (yet).
- **Hardcoded timeouts**: Internal timeouts (leader election: 3s, apply: 2s, transport: 10s, cluster join: 5m) are not configurable (yet).
- **Graceful leave**: Nodes support graceful cluster departure via `LeaveCluster()`, which removes the node from the Raft configuration before shutting down.
