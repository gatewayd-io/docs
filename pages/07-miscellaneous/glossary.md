# Glossary

## Object

Each configurable part of GatewayD is called an *object*, for example `logger`.

## Configuration file

GatewayD has two YAML-based configuration files that are shipped with each release file and contains all the default values.

- `gatewayd.yaml`: the global configuration file of GatewayD.
- `gatewayd_plugins.yaml`: the plugins configuration file.

## Configuration object

Each configuration file contains multiple configuration objects that correspond to GatewayD objects. For example, the global configuration file contains seven configuration objects: `loggers`, `metrics`, `clients`, `pools`, `proxies`, `server` and `API`.

## Configuration group

To enable multi-tenancy, GatewayD supports configuring multiple instances of each (configuration) object using configuration groups. All the default configuration objects have a single configuration group called `default`, except the `API`.

## Configuration parameter

A configuration object has one or many configuration parameters to set up the corresponding object. For example, the `output` parameter on the `logger` object is used to set the outputs by the `default` (configuration group) logger.

## Connection

A connection is a TCP/UDP/UDS connection between GatewayD and a database client. GatewayD can have multiple connections at the same time.

## Server

Server is an object that listens on an address:port pair and accepts connections from database clients.

## Client

Client object is a client that can connect to the databas servers over TCP, UDP and Unix Domain Socket.

## Database client

Database clients are either database drivers for different programming languages or any other client that can talk the database language, aka. the wire protocol.

## Database driver

A database driver is a library that allows a programming language to communicate with a database. For example, the [PostgreSQL](https://www.postgresql.org/) driver for [Python](https://www.python.org/) is called [psycopg](https://www.psycopg.org/).

## Database language

The database language is the language that the database server understands. For example, the [PostgreSQL](https://www.postgresql.org/) database server understands the [PostgreSQL wire protocol](https://www.postgresql.org/docs/current/protocol.html).

## Wire protocol

The wire protocol is the language that the database client and the database server understand. For example, the [PostgreSQL](https://www.postgresql.org/) database server understands the [PostgreSQL wire protocol](https://www.postgresql.org/docs/current/protocol.html).

## Database server

A database server is a server that hosts a database. For example, [PostgreSQL](https://www.postgresql.org/) is a database server.

## Database Management System (DBMS)

A database management system is a software that manages a database. For example, [PostgreSQL](https://www.postgresql.org/) is a database management system.

## Event

The server works in an event-based manner and many events will fire during the lifetime of the server and the database client connections.

## Proxy

The proxy object is responsible for handling the traffic between the database client and the database server and is directly connected to the [server](#server) object.

## Pool

The pool object is responsible for managing the [client](#client) objects and is directly connected to the [proxy](#proxy) object.

## Connection health check

The proxy object will periodically check the connection health by disconnecting stale connections the database server and creating the same number of new connections to the database server.

## Stale connection

A stale connection is a connection that has not been used for a long time and is considered unhealthy.
