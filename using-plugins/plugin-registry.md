---
last_modified_date: 2023-09-26 23:39:16 +0200
layout: default
title: Plugin registry
description: The plugin registry is a central place where all plugins are loaded, configured and executed, and also the main entry point for all plugins.
nav_order: 3
parent: Using Plugins
---

# Plugin Registry

The plugin registry is a central place where all plugins are loaded, configured and executed, and also the main entry point for all plugins. It uses a [generic pool](/using-gatewayd/pools) to manage loaded instances of plugins.

[Plugins](/using-gatewayd/configuration#plugins-configuration) and [global](/using-gatewayd/configuration#global-configuration) configurations are loaded first. Then, the [loggers](/using-gatewayd/global-configuration/loggers) are created and initialized. After that, the plugin registry is created and initialized. Plugin registry loads all the [plugins](/using-plugins/plugins), register their [hooks](/using-plugins/hooks) and start them. Finally, the [metrics merger](/using-plugins/plugins#metrics-merger) and the [health check](/using-plugins/plugins#health-check) are started.

The plugin registry also contains the [hook registry](/using-plugins/hook-registry) which is used to register and execute plugin hooks. As mentioned above, the plugin registry loads all the plugins and register their hooks. When a hook is run, the hook registry will find all the registered hooks for that hook type and execute them in sequence. The result of each hook is passed to the next hook in the chain. The result of the last hook in the chain is returned to GatewayD.

Upon graceful shutdown of GatewayD, the plugin registry will stop all the plugins, the health check and the metrics merger. All the other components are also stopped. Plugins can register to the [`onShutdown`](/using-plugins/hooks#hooks) hook to perform any cleanup tasks before GatewayD is stopped.
