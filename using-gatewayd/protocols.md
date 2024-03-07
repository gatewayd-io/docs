---
last_modified_date: 2024-03-07 22:33:34
layout: default
title: Protocols
description: GatewayD is application layer protocol-agnostic. This means that GatewayD *can* practically support any protocol in the application layer, or L7.
nav_order: 12
parent: Using GatewayD
---

# Protocols

GatewayD is application layer protocol-agnostic. This means that GatewayD *can* practically support any protocol in the application layer, or L7. However, it is not *recommended* to use GatewayD for non-database protocols, as it is not optimized for those protocols. The focus of GatewayD is to be a database [proxy](https://en.wikipedia.org/wiki/Proxy_server), and not a general purpose proxy. PostgreSQL has been chosen as the first database protocol to be supported, and more protocols will be added in the future.

## Supported L4 protocols

Both the [server](/using-gatewayd/servers) and the [client](/using-gatewayd/clients) objects supports the following transport layer protocols, which can be configured via the [global configuration](/using-gatewayd/configuration) file for the [server](/using-gatewayd/global-configuration/servers) and the [client](/using-gatewayd/global-configuration/clients) objects:

- **TCP** (default)
- **UDP**
- **Unix Domain Socket**

## Supported L7 protocols

GatewayD supports the following application layer protocols:

- **PostgreSQL** (default)

{: .wip }
> Other database protocols will be added in the future.
