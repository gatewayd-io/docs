---
last_modified_date: 2023-12-04 12:41:05 +0100
layout: default
title: Clients
description: GatewayD client configuration
nav_order: 3
parent: Global Configuration
grand_parent: Using GatewayD
---

# Clients

GatewayD supports multiple client configurations. Each client in each configuration group will connect to the same database server specified in the configuration parameters and will be added to its corresponding [pool](pools) based on their configuration group, i.e. `default`.

## Configuration parameters

| Name               | Type              | Default value  | Possible values        | Description                                                                                                           |
| ------------------ | ----------------- | -------------- | ---------------------- | --------------------------------------------------------------------------------------------------------------------- |
| network            | string            | tcp            | tcp, udp, unix         | The network protocol to use                                                                                           |
| address            | string            | localhost:5432 | Possible host:port     | Database server address. PostgreSQL for now.                                                                          |
| tcpKeepAlive       | boolean           | False          | True, False            | Whether to enable TCP keep-alive or not                                                                               |
| tcpKeepAlivePeriod | duration (string) | 30s            | Valid duration strings | Interval between each keep-alive packet                                                                               |
| receiveChunkSize   | number            | 8192           | Positive integers      | The amount of bytes to read per each call to receive (bytes)                                                          |
| receiveDeadline    | duration (string) | 0s             | Valid duration strings | The amount of time the client should wait before giving up on call to receive. `0s` disables receive deadline. This k |
| receiveTimeout     | duration (string) | 0s             | Valid duration strings | The amount of time the client should wait before giving up on call to receive. `0s` disables receive timeout.         |
| sendDeadline       | duration (string) | 0s             | Valid duration strings | The amount of time the client should wait before giving up on call to send. `0s` disables send deadline.              |
| dialTimeout        | duration (string) | 60s            | Valid duration strings | The amount of time the client should wait before giving up on dialing the database. `0s` disables dial timeout.       |
| retries            | number            | 3              | Positive integers      | The amount of times to retry a failed connection. `0` means no retry.                                                 |
| backoff            | duration (string) | 1s             | Valid duration strings | The amount of time to wait before retrying a failed connection. `0s` means no backoff.                                |
| backoffMultiplier  | number            | 2.0            | Positive integers      | The multiplier to apply to the backoff duration. `0` means no backoff.                                                |
| disableBackoffCaps | boolean           | False          | True, False            | Whether to disable the backoff caps for backoff multiplier and backoff duration.                                      |

```yaml
clients:
  default:
    network: tcp
    address: localhost:5432
    tcpKeepAlive: False
    tcpKeepAlivePeriod: 30s # duration
    receiveChunkSize: 8192
    receiveDeadline: 0s # duration, 0ms/0s means no deadline
    receiveTimeout: 0s # duration, 0ms/0s means no timeout
    sendDeadline: 0s # duration, 0ms/0s means no deadline
    dialTimeout: 60s # duration, 0ms/0s means no timeout
    # Retry configuration
    retries: 3 # 0 means no retry
    backoff: 1s # duration
    backoffMultiplier: 2.0 # 0 means no backoff
    disableBackoffCaps: false
```
