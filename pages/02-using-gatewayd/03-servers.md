# Servers

Server is an object that listens on an address:port pair and accepts connections from database clients. Database clients are either database drivers for different programming languages or any other client that can talk the database language, aka. the wire protocol.

A running instance of GatewayD can practically host multiple instances of the server object. The server object is configurable from the [`servers`](../02-using-gatewayd/01-configuration/01-global-configuration/06-servers.md) configuration object in the global configuration file: `gatewayd.yaml`. To have multiple servers listening on different ports, multiple [configuration groups](../07-miscellaneous/glossary.md#configuration-group) should be defined. The name of the group should be the same for other objects as well, so that `gatewayd` can connect them together.

The server works in an event-based manner and many events will fire during the lifetime of the server and the database client connections. These events are handled by the server:

| Event      | Description                                                                     |
| ---------- | ------------------------------------------------------------------------------- |
| OnBoot     | Fires when the server is ready for accepting connections                        |
| OnShutdown | Fires when the engine is being shut down                                        |
| OnOpen     | Fires when a new connection has been opened from the database client            |
| OnClose    | Fires when a connection has been closed by the database client or the server    |
| OnTraffic  | Fires when a socket receives data from the database client                      |
| OnTick     | Fires immediately after the server starts and will fire again after an interval |

The server object is responsible for accepting new connections from the database clients and creating a new [connection](../07-miscellaneous/glossary.md#connection) object for each connection. The connection object is responsible for handling the connection opened by the database client.

The server object is also responsible for handling the traffic between the database client and the database server. To do so, the server passes the traffic to the [proxy](../07-miscellaneous/glossary.md#proxy) object. The proxy object is responsible for handling the traffic between the database client and the database server, which is configurable from the [`proxies`](../02-using-gatewayd/01-configuration/01-global-configuration/05-proxies.md) configuration object in the global configuration file: `gatewayd.yaml`.

## Protocol support

The server object works in transport layer, which is layer four of the OSI model and layer three of the TCP/IP model. Therefore it doesn't care about the protocol being used in the upper layers. This means that the server object, and GatewayD in general, *can* practically support any protocol in the upper layers. However, it is not recommended to use GatewayD for non-database protocols, as it is not optimized for those protocols. The focus of GatewayD is to be a database proxy, and not a general purpose proxy. PostgreSQL has been chosen as the first database protocol to be supported, and more protocols will be added in the future.
