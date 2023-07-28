---
last_modified_date: 2023-04-25 11:42:35 +0200
layout: default
title: Proxies
description: Proxy object is used to create a binding between incoming connections from the database clients to the database servers.
nav_order: 7
parent: Using GatewayD
---

# Proxies

Proxy object is used to create a binding between incoming connections from the database clients to the database servers. Each incoming connection will connect to the [server](servers). Upon connection, the server object instructs the [proxy](proxies) object to assign an available [client](clients) object from the [pool](pools). If no client object is available, the proxy object will reject the incoming connection with an error.

If any traffic comes from the incoming connection, it will be forwarded to the server. It will wait for the server to respond and forward the response back to the incoming connection. The proxy object will also handle the connection health check and the connection timeout.

## Proxy object

The following sequence diagram shows how the proxy object works.

```mermaid
sequenceDiagram
    database client->>+server: connect
    server->>proxy: connect
    proxy->>available pool: give me a free connection
    available pool->>proxy: here is a free connection
    proxy->>busy pool: assign connections
    busy pool->>proxy: done
    proxy->>server: done
    server->>database client: ready
```

{: .note }
> Both the available pool and the busy pool are created and managed by the proxy object.

## Traffic handling

The following sequence diagram shows how the proxy object handles the traffic.

```mermaid
sequenceDiagram
    database client->>+server: query
    server->>proxy: there is traffic from database client
    proxy->>busy pool: give me the connected client
    busy pool->>proxy: here is the connected client
    proxy->>connected client: send query to database
    connected client->>database: send query
    database->>connected client: receive response
    connected client->>proxy: here is the response from database
    proxy->>server: send response to database client
    server->>database client: response
```

## Connection health check

The proxy object will periodically check the connection health by disconnecting stale connections the database server and creating the same number of new connections to the database server. The following sequence diagram shows how the proxy object handles the connection health check. Stale connections are connections that have not been used for a long time and are considered unhealthy.

```mermaid
sequenceDiagram
    proxy health check->>available pool: Are there any available clients?
    available pool->>proxy health check: Yes
    proxy health check->>clients: Terminate the client(s)
    proxy health check->>available pool: Remove the client
    proxy health check->>clients: Create new client(s)
    clients->>proxy health check: Here are the new client(s)
    proxy health check->>available pool: Store the connections
```
