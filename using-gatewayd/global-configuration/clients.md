---
last_modified_date: 2026-02-16 22:23:38
layout: default
title: Clients
description: GatewayD client configuration
nav_order: 3
parent: Global Configuration
grand_parent: Using GatewayD
---

# Clients

GatewayD supports multiple client configurations. Each client within a configuration group will connect to a database server specified in the configuration parameters and will be added to its corresponding [pool](pools) based on their configuration group (e.g., `default`) and configuration block (e.g., `writes`).

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
| startupParams      | object            | (not set)      | See below              | PostgreSQL startup parameters for pre-authenticating backend connections. When set, GatewayD performs the PostgreSQL startup handshake (including authentication) immediately after establishing each backend TCP connection. |

### startupParams

The `startupParams` option enables pre-authentication of backend pool connections. When configured, GatewayD performs the full PostgreSQL startup handshake (including authentication via trust, cleartext, MD5, or SCRAM-SHA-256) right after each backend TCP connection is established. This means pool connections are already authenticated and ready for queries when a database client connects.

When `startupParams` is configured, GatewayD also uses a lightweight `DISCARD ALL` session reset instead of tearing down and recreating backend connections when a database client disconnects. This is significantly cheaper than a full reconnect.

| Name     | Type   | Default value | Possible values | Description                                      |
| -------- | ------ | ------------- | --------------- | ------------------------------------------------ |
| user     | string | (required)    | Valid username  | The PostgreSQL user for backend authentication.  |
| database | string | (required)    | Valid database  | The PostgreSQL database for backend connections.  |
| password | string | (required)    | Valid password  | The password for backend authentication.          |

```yaml
clients:
  default:
    writes:
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
      # PostgreSQL pre-authentication (optional)
      # startupParams:
      #   user: postgres
      #   database: postgres
      #   password: postgres
```
