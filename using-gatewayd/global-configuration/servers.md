---
last_modified_date: 2023-11-19 14:31:13 +0100
layout: default
title: Servers
description: GatewayD server configuration
nav_order: 6
parent: Global Configuration
grand_parent: Using GatewayD
---

# Servers

The server object runs to listen for incoming connections from database clients. It supports TLS termination, if enabled. The server object has the following parameters:

## Configuration parameters

| Name             | Type    | Default value | Possible values | Description                         |
| ---------------- | ------- | ------------- | --------------- | ----------------------------------- |
| network          | string  | tcp           | tcp, unix       | The network protocol to use         |
| address          | string  | 0.0.0.0:15432 | Valid host:port | The address to listen on            |
| enableTicker     | boolean | False         | True, False     | Whether to enable the ticker or not |
| tickInterval     | string  | 5s            | Valid duration  | The interval of the ticker          |
| enableTLS        | boolean | False         | True, False     | Whether to enable TLS or not        |
| certFile         | string  |               | Valid path      | The path to the TLS certificate     |
| keyFile          | string  |               | Valid path      | The path to the TLS key             |
| handshakeTimeout | string  | 5s            | Valid duration  | The timeout for TLS handshake       |

## Example configuration

```yaml
servers:
  default:
    network: tcp
    address: 0.0.0.0:15432
    enableTicker: False
    tickInterval: 5s # duration
    enableTLS: False
    certFile: ""
    keyFile: ""
    handshakeTimeout: 5s # duration
```
