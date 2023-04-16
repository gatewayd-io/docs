# Plugin Registry

The plugin registry is a central place where all plugins are loaded, configured and executed, and also the main entry point for all plugins. It uses a [generic pool](../02-using-gatewayd/05-pools.md) to manage loaded instances of plugins.

[Plugins](../02-using-gatewayd/01-configuration/index.md#plugins-configuration) and [global](../02-using-gatewayd/01-configuration/index.md#global-configuration) configurations are loaded first. Then, the [loggers](../02-using-gatewayd/01-configuration/01-global-configuration/01-loggers.md) are created and initialized. After that, the plugin registry is created and initialized. Plugin registry loads all the [plugins](01-plugins.md), register their [hooks](02-hooks.md) and start them. Finally, the [metrics merger](01-plugins.md#metrics-merger) and the [health check](01-plugins.md#health-check) are started.

The plugin registry also contains the [hook registry](04-hook-registry.md) which is used to register and execute plugin hooks. As mentioned above, the plugin registry loads all the plugins and register their hooks. When a hook is run, the hook registry will find all the registered hooks for that hook type and execute them in sequence. The result of each hook is passed to the next hook in the chain. The result of the last hook in the chain is returned to GatewayD.

Upon graceful shutdown of GatewayD, the plugin registry will stop all the plugins, the health check and the metrics merger. All the other components are also stopped. Plugins can register to the [`onShutdown`](02-hooks.md#hooks) hook to perform any cleanup tasks before GatewayD is stopped.
