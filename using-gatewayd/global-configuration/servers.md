---
last_modified_date: 2023-10-20 00:52:55 +0200
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

| Name         | Type    | Default value | Possible values | Description                         |
| ------------ | ------- | ------------- | --------------- | ----------------------------------- |
| network      | string  | tcp           | tcp, unix       | The network protocol to use         |
| address      | string  | 0.0.0.0:15432 | Valid host:port | The address to listen on            |
| enableTicker | boolean | False         | True, False     | Whether to enable the ticker or not |
| tickInterval | string  | 5s            | Valid duration  | The interval of the ticker          |

## Example configuration

```yaml
servers:
  default:
    network: tcp
    address: 0.0.0.0:15432
    enableTicker: False
    tickInterval: 5s # duration
```
