---
last_modified_date: 2024-04-16 09:21:37
layout: default
title: Proxies
description: GatewayD proxy configuration
nav_order: 5
parent: Global Configuration
grand_parent: Using GatewayD
---

# Proxies

The proxy object is used to proxy connections between database clients and servers.

GatewayD supports a fixed proxy that creates a pool with a fixed number of connection to the database server. It honors the pool capacity, and if the number of connections from the clients is more than the capacity, new connections will be rejected.

The PostgreSQL database expects new connections to authenticate before keeping them connected forever, thus the TCP connections from GatewayD will be timed out and dropped. A health check scheduler is started when creating connections to the database. If there are connections available in the available connections pool after the `healthCheckPeriod` is reached, it will remove and recreate new TCP connections to the database and put them in the pool.

Each proxy has two pools:

1. **Available connections pool**: new connections will be created upon start, and they will be put into this pool.
2. **Busy connections pool**: when a new database client is connected to GatewayD, a connection will be removed from the available connections pool and put into this pool. Later when the client is disconnected, the connection will be closed and a new connection will be put back into the available connections pool.

## Configuration parameters

| Name                | Type              | Default value | Possible values        | Description                     |
| ------------------- | ----------------- | ------------- | ---------------------- | ------------------------------- |
| healthCheckPeriod   | duration (string) | 60s           | Valid duration strings | Intervals between health checks |

## Example configuration

```yaml
proxies:
  default:
    healthCheckPeriod: 60s # duration
```