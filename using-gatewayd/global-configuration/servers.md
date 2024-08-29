---
last_modified_date: 2024-07-30 16:45:29
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

| Name                                   | Type    | Default value | Possible values                             | Description                                                                 |
| -------------------------------------- | ------- | ------------- | -------------------------------------------- | --------------------------------------------------------------------------- |
| network                                | string  | tcp           | tcp, unix                                    | The network protocol to use                                                 |
| address                                | string  | 0.0.0.0:15432 | Valid host:port                              | The address to listen on                                                    |
| enableTicker                           | boolean | False         | True, False                                  | Whether to enable the ticker or not                                         |
| tickInterval                           | string  | 5s            | Valid duration                               | The interval of the ticker                                                  |
| enableTLS                              | boolean | False         | True, False                                  | Whether to enable TLS or not                                                |
| certFile                               | string  |               | Valid path                                   | The path to the TLS certificate                                             |
| keyFile                                | string  |               | Valid path                                   | The path to the TLS key                                                     |
| handshakeTimeout                       | string  | 5s            | Valid duration                               | The timeout for TLS handshake                                               |
| loadBalancer                           | object  |               |                                              | Configuration for the load balancer                                         |
| loadBalancer.strategy                  | string  | ROUND_ROBIN   | ROUND_ROBIN, RANDOM, WEIGHTED_ROUND_ROBIN    | The strategy used to distribute connections                                 |
| loadBalancer.consistentHash            | object  |               |                                              | Configuration for consistent hash-based load balancing                      |
| loadBalancer.consistentHash.useSourceIp | boolean | False         | True, False                                  | Whether to use the source IP for consistent hashing                         |
| loadBalancer.loadBalancingRules        | array   |               | List of rules                                | Optional configuration for strategies that support rules (e.g., WEIGHTED_ROUND_ROBIN) |
| loadBalancingRules.condition           | string  | DEFAULT       | DEFAULT                                      | Condition for the load balancing rule (currently, only "DEFAULT" is supported) |
| loadBalancingRules.distribution        | array   |               | List of proxyName and weight pairs           | Defines the weight distribution for proxies in the load balancing strategy  |
| distribution.proxyName                 | string  |               | Valid proxy name                             | Name of the proxy server (e.g., "writes", "reads")                          |
| distribution.weight                    | integer |               | Positive integer                             | Weight assigned to a proxy in the load balancing distribution               |


### Example Configuration

```yaml
servers:
  default:
    network: tcp
    address: 0.0.0.0:15432
    loadBalancer:
      strategy: ROUND_ROBIN # ROUND_ROBIN, RANDOM, WEIGHTED_ROUND_ROBIN
      consistentHash:
        useSourceIp: true
      # Optional configuration for strategies that support rules (e.g., WEIGHTED_ROUND_ROBIN)
      # loadBalancingRules:
      #   - condition: "DEFAULT" # Currently, only the "DEFAULT" condition is supported
      #     distribution:
      #       - proxyName: "writes"
      #         weight: 70
      #       - proxyName: "reads"
      #         weight: 30
    enableTicker: False
    tickInterval: 5s # duration
    enableTLS: False
    certFile: ""
    keyFile: ""
    handshakeTimeout: 5s # duration
```
