---
last_modified_date: 2023-07-31 19:28:44 +0200
layout: default
title: Pools
description: GatewayD has a generic internal pool object that is used to manage plugins and connections.
nav_order: 6
parent: Using GatewayD
---

# Pools

GatewayD has a generic internal pool object that is used to manage plugins and connections. Two concrete usages of the generic pool across GatewayD for managing other objects are listed below.

| Name                  | Relation        | Description                                                                                                                                                                                              | key                      | value         |
| --------------------- | --------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------ | ------------- |
| available connections | proxy           | Newly created client objects are added to the available connections pool for use in the proxy object.                                                                                                    | client ID (string)       | client object |
| busy connections      | proxy           | A new connection to the server object will cause the proxy to pop a client from the available connection pool and put it in the busy connections pool, effectively proxying between the two connections. | server connection object | client object |
| plugins               | plugin registry | Loaded plugins are put into the pool for easier management.                                                                                                                                              | plugin ID (struct)       | plugin object |

## Size, length and capacity

The size of the pool, that is set in the [pool](/using-gatewayd/global-configuration/pools) configuration, refers to the maximum capacity of the pool object, that is, how many objects it can possibly hold. The length of the pool is the current size of the object, that is, how many object it currently has.

An empty pool, or zero-sized pool, has no upper-bound limit and it is used in the plugin registry.

{: .warning }
> It is *not* recommended to set the size of the pool to zero, as it might causes the pool to grow infinitely and cause unknown behaviors.
