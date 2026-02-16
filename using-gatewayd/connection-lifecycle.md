---
last_modified_date: 2026-02-16 22:23:38
layout: default
title: Connection Lifecycle
description: Connection Lifecycle of GatewayD
nav_order: 11
parent: Using GatewayD
---

# Connection Lifecycle

The connection lifecycle is the process of establishing a connection between a client and a server. This process is initiated by the client and is completed when the client disconnects from the server. In doing so, the client and server exchange data, in the form of queries and responses, which are sent over the connection and processed by the GatewayD and its plugins.

The connection lifecycle is composed of the following steps:

1. GatewayD starts with a pool of client connections to database server. If [`startupParams`](/using-gatewayd/global-configuration/clients#startupparams) is configured, each connection performs the PostgreSQL startup handshake (including authentication) immediately, so pool connections are pre-authenticated and ready for queries.
2. The database client initiates a connection to the GatewayD.
3. GatewayD accepts the connection and assigns it to a client connection.
4. The client sends a query to the GatewayD.
5. GatewayD proxies (forwards) the query to the database server.
6. GatewayD receives the response from the database server.
7. GatewayD sends the response to the client.
8. Database client disconnects from GatewayD.
9. The client connection is recycled. If `startupParams` is configured, GatewayD sends `DISCARD ALL` to reset the session state without closing the TCP connection. Otherwise, the connection is closed and a new one is created.
10. The recycled or new client connection is returned to the pool of client connections.
11. The process repeats from step 2.

The above steps are partially illustrated in [traffic handling diagram](/using-gatewayd/proxies#traffic-handling) of the proxies page.

## Connection lifecycle diagram

```mermaid
sequenceDiagram
    participant Database Client
    participant Server
    participant Proxy
    participant Pool
    participant Client
    participant Plugins
    participant Database Server

    Database Client->>+Server: Connect
    Server->>Plugins: OnOpening (notification)
    Server->>Proxy: Connect
    Proxy->>Pool: Get a connected client
    Pool->>Proxy: Here is a client
    Proxy->>Server: Connected
    Server->>Plugins: OnOpened (notification)
    Server->>Database Client: Connected
    Database Client->>Server: Authenticate/Query
    Server->>Plugins: OnTraffic (notification)
    Server->>Proxy: Incoming traffic
    Proxy->>Pool: Get connected client
    Proxy->>Plugins: OnTrafficFromClient (traffic)
    Proxy->>Client: Send auth/query data to database server
    Client->>Database Server: Send auth/query data to database server
    Proxy->>Plugins: OnTrafficToServer (traffic)
    Database Server->>Client: Receive auth/query response from database server
    Client->>Proxy: Received auth/query response from database server
    Proxy->>Plugins: OnTrafficFromServer (traffic)
    Proxy->>Server: Send auth/query response to database client
    Server->>Database Client: Send auth/query response to database client
    Proxy->>Plugins: OnTrafficToClient (traffic)
```
