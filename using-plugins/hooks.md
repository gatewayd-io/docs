---
last_modified_date: 2024-01-16 20:49:17 +0100
layout: default
title: Hooks
description: Plugins can be used to modify the connection lifecycle. Each step in the connection lifecycle is represented by one or more plugin hook(s). Plugins can register themselves to be called when a specific hook is triggered.
nav_order: 2
parent: Using Plugins
---

# Hooks

Plugins can be used to modify the connection lifecycle. Each step in the connection lifecycle is represented by one or more plugin hook(s). Plugins can register themselves to be called when a specific hook is triggered. The following table lists the available hooks and the corresponding plugin hook(s).

Each plugin can register to one or more hooks. The plugin will be called when the hook is triggered. The plugin can then perform any action it wants. The plugin can also return a value that will be passed to the next plugin in the chain. The last plugin in the chain will return the value to GatewayD.

| Hook                  | Type         | Description                                                                                                                                                                                                            |
| --------------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `onConfigLoaded`      | Config       | Called when the GatewayD configuration is loaded. Can change the global configuration.                                                                                                                                 |
| `onNewLogger`         | Notification | Called when a new logger is created.                                                                                                                                                                                   |
| `onNewPool`           | Notification | Called when a new pool is created.                                                                                                                                                                                     |
| `onNewClient`         | Notification | Called when a new client is created.                                                                                                                                                                                   |
| `onNewProxy`          | Notification | Called when a new proxy is created.                                                                                                                                                                                    |
| `onNewServer`         | Notification | Called when a new server is created.                                                                                                                                                                                   |
| `onSignal`            | Notification | Called when an OS signal is received.                                                                                                                                                                                  |
| `onRun`               | Notification | Called when the GatewayD is started.                                                                                                                                                                                   |
| `onBooting`           | Notification | Called when the GatewayD is booting.                                                                                                                                                                                   |
| `onBooted`            | Notification | Called when the GatewayD is booted.                                                                                                                                                                                    |
| `onOpening`           | Notification | Called when a new connection is being opened by a database client. This happens before the proxy connects the incoming connection to a client in the pool.                                                             |
| `onOpened`            | Notification | Called when a new connection is opened by a database client. This happens after the proxy connects the incoming connection to a client in the pool.                                                                    |
| `onClosing`           | Notification | Called when a connection is being closed by a database client. This happens before the proxy disconnects the client from the pool.                                                                                     |
| `onClosed`            | Notification | Called when a connection is closed by a database client. This happens after the proxy disconnects the client from the pool.                                                                                            |
| `onTraffic`           | Notification | Called when traffic is received from a database client.                                                                                                                                                                |
| `onTrafficFromClient` | Traffic      | Called when traffic is received from a database client, aka. the request. Plugins can terminate the connection and return a response or an error. They can also modify the request before it is proxied to the server. |
| `onTrafficToServer`   | Traffic      | Called when traffic is sent to a database server. Plugins will receive a copy of the request sent to the server.                                                                                                       |
| `onTrafficFromServer` | Traffic      | Called when traffic is received from a database server, aka. the response. Plugins can also modify the response before it is sent to the client. Plugins receive a copy of the request as well as the response.        |
| `onTrafficToClient`   | Traffic      | Called when traffic is sent to a database client.  Plugins receive a copy of the request as well as the response.                                                                                                      |
| `onShutdown`          | Notification | Called when the GatewayD is shutting down.                                                                                                                                                                             |
| `onTick`              | Notification | Called on intervals set in the global configuration of the server object.                                                                                                                                              |
| `onHook`              | Notification | Called when a custom hook is triggered. This is reserved for future uses in GatewayD.                                                                                                                                  |

## Types

Currently three types of hooks exist:

- `Config` hooks are called when the GatewayD configuration is loaded. They can change the global configuration.
- `Notification` hooks are called when a specific event occurs. They cannot change the objects' configuration.
- `Traffic` hooks are called when traffic is received from a database client, aka. the request or from a database server, aka. the response. Plugins can terminate the connection and return a response or an error. They can also modify the request or the response before it is proxied to the server or sent to the client.

## Timeout

For more information about the timeout, see [timeout](/using-plugins/plugins#timeout).
