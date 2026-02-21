---
last_modified_date: 2026-02-21 12:00:00
layout: default
title: gatewayd-plugin-cdc
description: GatewayD plugin for change data capture (CDC).
nav_order: 5
parent: Plugins
---

# gatewayd-plugin-cdc

{: .wip }
> This plugin is under active development. Documentation will be expanded as the plugin matures.

The gatewayd-plugin-cdc is a GatewayD plugin for change data capture (CDC). It captures changes happening in the database and sends them to another database or message broker like Kafka. It can be used for seamless logical replication and building real-time data pipelines, data warehousing, and more.

## Use cases

- **Logical replication**: Replicate data changes from one database to another without modifying application code.
- **Real-time data pipelines**: Stream database changes to message brokers like Kafka for downstream processing.
- **Data warehousing**: Keep analytical databases in sync with operational databases.
- **Event-driven architectures**: Trigger downstream services based on database changes.

## Links

- [GitHub Repository](https://github.com/gatewayd-io/gatewayd-plugin-cdc)
