# Protocols

GatewayD is application layer protocol-agnostic. This means that GatewayD *can* practically support any protocol in the application layer, or L7. However, it is not *recommended* to use GatewayD for non-database protocols, as it is not optimized for those protocols. The focus of GatewayD is to be a database [proxy](https://en.wikipedia.org/wiki/Proxy_server), and not a general purpose proxy. PostgreSQL has been chosen as the first database protocol to be supported, and more protocols will be added in the future.

## Supported L4 protocols

Both the [server](03-servers.md) and the [client](04-clients.md) objects supports the following transport layer protocols, which can be configured via the [global configuration](01-configuration/index.md) file for the [server](01-configuration/01-global-configuration/06-servers.md) and the [client](01-configuration/01-global-configuration/03-clients.md) objects:

- **TCP** (default)
- **UDP**
- **Unix Domain Socket**

## Supported L7 protocols

GatewayD supports the following application layer protocols:

- **PostgreSQL** (default)

**🚧 WIP**
Other database protocols will be added in the future.
