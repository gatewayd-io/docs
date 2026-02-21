---
last_modified_date: 2026-02-21 21:44:00
layout: default
title: Plugin registry
description: The plugin registry is a central place where all plugins are loaded, configured and executed, and also the main entry point for all plugins.
nav_order: 3
parent: Using Plugins
---

# Plugin Registry

The plugin registry is a central place where all plugins are loaded, configured and executed, and also the main entry point for all plugins. It uses a [generic pool](/using-gatewayd/pools) to manage loaded instances of plugins.

## Startup sequence

The plugin registry follows a strict initialization order during GatewayD startup:

1. [Plugin](/using-gatewayd/configuration#plugins-configuration) and [global](/using-gatewayd/configuration#global-configuration) configurations are loaded.
2. [Loggers](/using-gatewayd/global-configuration/loggers) are created and initialized.
3. The plugin registry is created and initialized.
4. For each plugin defined in the configuration (in order):
   - The plugin binary is verified (checksum validation, unless dev mode is enabled).
   - The plugin subprocess is launched via gRPC with auto-mTLS.
   - Plugin metadata is fetched (name, version, hooks, dependencies).
   - Dependencies are validated -- required plugins must already be loaded.
   - The plugin is added to the registry and its [hooks](/using-plugins/hooks) are registered.
5. The [metrics merger](/using-plugins/plugins#metrics-merger) and the [health check](/using-plugins/plugins#health-check) are started.

## Plugin priority

Plugin priority determines the order in which hooks are executed. Priority is assigned automatically based on the order plugins appear in the configuration file: the first plugin gets priority 1000, the second 1001, and so on. Lower values execute first.

If two plugins register for the same hook at the same priority, the later one replaces the earlier one and a warning is logged.

## Hook registry

The plugin registry contains the [hook registry](/using-plugins/hook-registry) which is used to register and execute plugin hooks. When a hook is run, the hook registry finds all registered hooks for that hook type, sorts them by priority, and executes them in sequence. The result of each hook is passed as input to the next hook in the chain. The result of the last hook in the chain is returned to GatewayD.

## Health check and crash recovery

The plugin registry runs a periodic health check (configurable via [`healthCheckPeriod`](/using-gatewayd/plugins-configuration/general-configurations#configuration-parameters)) that pings each plugin over gRPC. If a plugin fails the health check:

1. The plugin is removed from the metrics merger.
2. The plugin is removed from the registry.
3. If [`reloadOnCrash`](/using-gatewayd/plugins-configuration/general-configurations#configuration-parameters) is enabled, the plugin is automatically reloaded from its original configuration.

## Shutdown

Upon graceful shutdown of GatewayD, the plugin registry stops all plugins, the health check, and the metrics merger. All other components are also stopped. Plugins can register to the [`onShutdown`](/using-plugins/hooks) hook to perform cleanup tasks before GatewayD exits.
