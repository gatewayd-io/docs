---
last_modified_date: 2023-11-19 14:31:13 +0100
layout: default
title: Servers
description: Server is an object that listens on an address:port pair and accepts connections from database clients.
nav_order: 4
parent: Using GatewayD
---

# Servers

Server is an object that listens on an address:port pair and accepts connections from database clients. Database clients are either database drivers for different programming languages or any other client that can talk the database language, aka. the wire protocol.

## Listening on multiple addresses

A running instance of GatewayD can practically host multiple instances of the server object. The server object is configurable from the [`servers`](/using-gatewayd/global-configuration/servers) configuration object in the global configuration file: `gatewayd.yaml`. To have multiple servers listening on different ports, multiple [configuration groups](/miscellaneous/glossary#configuration-group) should be defined. The name of the group should be the same for other objects as well, so that `gatewayd` can connect them together.

## Events

The server works in an event-based manner and many events will fire during the lifetime of the server and the database client connections. These events are handled by the server:

| Event      | Description                                                                     |
| ---------- | ------------------------------------------------------------------------------- |
| OnBoot     | Fires when the server is ready for accepting connections                        |
| OnShutdown | Fires when the engine is being shut down                                        |
| OnOpen     | Fires when a new connection has been opened from the database client            |
| OnClose    | Fires when a connection has been closed by the database client or the server    |
| OnTraffic  | Fires when a socket receives data from the database client                      |
| OnTick     | Fires immediately after the server starts and will fire again after an interval |

## Connection handling

The server object is responsible for accepting new connections from the database clients and creating a new [connection](/miscellaneous/glossary#connection) object for each connection. The connection object is responsible for handling the connection opened by the database client.

## Traffic handling

The server object is also responsible for handling the traffic between the database client and the database server. To do so, the server passes the traffic to the [proxy](/miscellaneous/glossary#proxy) object. The proxy object is responsible for handling the traffic between the database client and the database server, which is configurable from the [`proxies`](/using-gatewayd/global-configuration/proxies) configuration object in the global configuration file: `gatewayd.yaml`.

## Protocol support

The server object works in the [transport layer](https://en.wikipedia.org/wiki/Transport_layer), which is Layer 4, or L4, of the [OSI model](https://en.wikipedia.org/wiki/OSI_model). Therefore it doesn't care about the protocol being used in the upper layers. This means that the server object, and GatewayD in general, *can* practically support any protocol in the upper layers. However, it is not *recommended* to use GatewayD for non-database protocols, as it is not optimized for those protocols. The focus of GatewayD is to be a database proxy, and not a general purpose proxy. PostgreSQL has been chosen as the first database protocol to be supported, and more protocols will be added in the future.

## Connection limits

The server can accept an unlimited number of connections. However, the [pool](pools) object limits the number of connections that can be opened to the database server.

## Ticker

The server object has a ticker that fires every `tickInterval` seconds. The `tickInterval` value is configurable from the [`servers`](/using-gatewayd/global-configuration/servers) configuration object in the global configuration file: `gatewayd.yaml`. The ticker is used to perform periodic tasks, but it is disabled by default. Plugins can use the ticker to perform periodic tasks.

## TLS termination

The server object supports TLS termination, which means that the server object can accept TLS connections from the database clients and forward the traffic to the database server in plain text. The TLS parameters are configurable from the [`servers`](/using-gatewayd/global-configuration/servers) configuration object in the global configuration file: `gatewayd.yaml`.
