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

## Plugins

Plugins play a very important role in GatewayD for adding support for different databases. They are the building blocks of GatewayD, and they are responsible for the majority of the functionality of GatewayD. GatewayD itself does not contain any database specific code, and instead relies on plugins to add support for different databases.

Plugins are loaded on startup and are responsible for the following:

- Sending/receiving the protocol-specific data from the client and server
- Parsing the protocol-specific data
- Extracting information from the protocol-specific data
- Performing actions based on the extracted information
- Parsing SQL queries from the client
- Parsing responses from the server

For example, the [gatewayd-plugin-cache](https://github.com/gatewayd-io/gatewayd-plugin-cache) decodes the [PostgreSQL wire protocol](../07-miscellaneous/glossary.md#postgresql-wire-protocol), extracts the SQL select query from the client, and then caches the result of the query in Redis. The next time the same select query is sent, the plugin will return the cached result instead of sending the query to the server. It also checks if the query is an upsert, delete, alter or drop query, and it will invalidate the cache based on the table in the query. This is a very simple example of what a plugin can do.
<!-- Plugins are generally written in Go, but can be written in any other language, and are compiled into a stand-alone executable file to be run by GatewayD. The executable is then loaded by GatewayD at startup. -->
