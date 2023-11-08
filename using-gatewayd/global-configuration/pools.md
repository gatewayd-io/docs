---
last_modified_date: 2023-11-05 18:05:24 +0100
layout: default
title: Pools
description: GatewayD pool configuration
nav_order: 4
parent: Global Configuration
grand_parent: Using GatewayD
---

# Pools

A pool is an object that holds a set of client connections. It is subsequently used by the [proxy](/using-gatewayd/global-configuration/proxies) object to manage client and server connections.

The size of the pool defines the maximum capacity of the pool. Upon start, GatewayD creates as many client connections to the database server, e.g. PostgreSQL, as the capacity allows. If GatewayD fails to connect on each connection, it will shut down gracefully and will send an error log to the selected log outputs with the cause.

## Configuration parameters

| Name | Type   | Default value | Possible values   | Description                                                                                                                             |
| ---- | ------ | ------------- | ----------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| size | number | 10            | Positive integers | Since this creates many parallel connections to the database, setting it to a very high value will degrade performance of the database. |

```yaml
pools:
  default:
    size: 10
```
