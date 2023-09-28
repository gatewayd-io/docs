---
last_modified_date: 2023-09-28 16:14:41 +0200
layout: default
title: Servers
description: GatewayD server configuration
nav_order: 6
parent: Global Configuration
grand_parent: Using GatewayD
---

# Servers

The server object runs to listen for incoming connections from database clients. The server object has the following parameters:

## Configuration parameters

| Name             | Type    | Default value | Possible values    | Description                            |
| ---------------- | ------- | ------------- | ------------------ | -------------------------------------- |
| network          | string  | tcp           | tcp, unix          | The network protocol to use            |
| address          | string  | 0.0.0.0:15432 | Valid host:port    | The address to listen on               |
| enableTicker     | boolean | False         | True, False        | Whether to enable the ticker or not    |
| tickInterval     | string  | 5s            | Valid duration     | The interval of the ticker             |
| multiCore        | boolean | True          | True, False        | Whether to enable multi-core or not    |
| lockOSThread     | boolean | False         | True, False        | Whether to lock the OS thread or not   |
| loadBalancer     | string  | roundrobin    | roundrobin, random | The load balancer to use               |
| readBufferCap    | number  | 134217728     | Positive integers  | The read buffer capacity (bytes)       |
| writeBufferCap   | number  | 134217728     | Positive integers  | The write buffer capacity (bytes)      |
| socketRecvBuffer | number  | 134217728     | Positive integers  | The socket receive buffer size (bytes) |
| socketSendBuffer | number  | 134217728     | Positive integers  | The socket send buffer size (bytes)    |
| reuseAddress     | boolean | True          | True, False        | Whether to reuse the address or not    |
| reusePort        | boolean | True          | True, False        | Whether to reuse the port or not       |
| tcpKeepAlive     | string  | 3s            | Valid duration     | The TCP keep alive duration            |
| tcpNoDelay       | boolean | True          | True, False        | Whether to enable TCP no delay or not  |

## Example configuration

```yaml
servers:
  default:
    network: tcp
    address: 0.0.0.0:15432
    enableTicker: False
    tickInterval: 5s # duration
    multiCore: True
    lockOSThread: False
    loadBalancer: roundrobin
    readBufferCap: 134217728
    writeBufferCap: 134217728
    socketRecvBuffer: 134217728
    socketSendBuffer: 134217728
    reuseAddress: True
    reusePort: True
    tcpKeepAlive: 3s # duration
    tcpNoDelay: True
```
