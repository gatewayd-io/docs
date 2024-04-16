---
last_modified_date: 2024-04-16 08:43:06
layout: default
title: Hook registry
description: The hook registry is a central place where all hooks are registered and executed. It is used by the plugin registry to register and execute plugin hooks.
nav_order: 4
parent: Using Plugins
---

# Hook Registry

The hook registry is a central place where all hooks are registered and executed. It is used by the [plugin registry](/using-plugins/plugin-registry) to register and execute plugin hooks. When a hook is run, the hook registry will find all the registered hooks for that hook type and execute them in sequence. The result of each hook is passed to the next hook in the chain. The result of the last hook in the chain is returned to GatewayD.

## Hooks

Hooks are used to extend the functionality of GatewayD. They are used to add new features, modify existing features, or to add custom logic to GatewayD. Hooks are registered by plugins and executed by the plugin registry. The plugin registry uses the hook registry to register and execute hooks.

For more information about hooks, see [hooks](/using-plugins/hooks).
