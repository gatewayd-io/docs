# Welcome to the GatewayD documentation

This documentation will help you go from a beginner to an advanced user and developer of GatewayD!

## Get Started

- [Installation](/installation)
- [Running GatewayD](/running-gatewayd)

## What is GatewayD?

GatewayD is a free and open-source cloud-native database gateway and framework for building data-driven applications. It sits between your database servers and clients and proxies all their communication. It is like API gateways, but for databases.

Using GatewayD, you can see through the queries and the data passing between your database server and clients, and take action when needed. For example, you can cache the result of SQL SELECT queries or detect and prevent SQL injection attacks.

GatewayD itself is an L4 transparent gateway for SQL databases and clients. You can either write your own plugins or make use of our built-in, community and enterprise plugins.

k6 is developed by [GatewayD Labs](https://gatewayd.io) and the community.

## Key features

GatewayD is packed with features, which you can learn all about in the documentation. Key features include:

✅ CLI tool with developer-friendly APIs
✅ Plugins in Go, Python and any language supporting gRPC and Protocol Buffers
✅ Work out of the box with zero to none changes to your code and database

## Use cases

GatewayD users are typically Developers, DBAs, DBREs, Security Engineers, Compliance Auditors, SREs and Cloud Engineers and basically anyone working with databases. These engineers use GatewayD for proxying SQL queries and their responses and taking action when those queries and responses meet certain criteria. Common GatewayD use cases are:

- **Transport L4 database gateway**
GatewayD is optimized for proxying SQL databases and clients.
- **Caching results of queries**
The [`gatewayd-plugin-cache`](https://github.com/gatewayd-io/gatewayd-plugin-cache) is a free and open-source plugin that parses PostgreSQL database traffic, extracts the query and caches its response with a TTL. Further queries will be served from the cached results. Upsert, delete, alter and drop statements invalidate cached results.
- **Advanced caching**
The [`gatewayd-plugin-cache-advacned`](..) is an enterprise plugin that works like its free and open-source counterpart, except it monitors the Write-Ahead-Log (WAL) of PostgreSQL for invalidating cached results. So, even if any client accesses the database directly and changes anything, the plugin checks the WAL and invalidates all the matching cached results immediately.
- **SQL injection detection and prevention** (WIP)
The `gatewayd-plugin-idp` is an entperise plugin that uses a machine-learning model trained with lots of SQL injection attack patterns. It can detect SQL injection attacks and take immediate and preventive actions to stop attackers from compromising your database and your precious data.

These are just a few examples and the list is by no means exhastive, as new plugins are constantly developed.

## What GatewayD does not do?

GatewayD is not a silver bullet and won't solve all your database problems over night. You still have to design and normalize your database schema, take and test backups, secure your database and do whatever you used to do before GatewayD. GatewayD came into exsitence to fix the black box mentality that surrounds databases to this very day.

Over time many plugins will be developed either by us or the community that will try to solve different issues arose from utilizing databases.

GatewayD is originally designed to be database-neutral, and proxy traffic to and from SQL and NoSQL databases. However, for practicality reasons, we focused on PostgreSQL at the moment. We will be working towards adding support for other SQL and NoSQL databases in the future.