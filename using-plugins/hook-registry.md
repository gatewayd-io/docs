---
last_modified_date: 2026-02-21 21:44:00
layout: default
title: Hook registry
description: The hook registry is a central place where all hooks are registered and executed. It is used by the plugin registry to register and execute plugin hooks.
nav_order: 4
parent: Using Plugins
---

# Hook Registry

The hook registry is a central place where all hooks are registered and executed. It is used by the [plugin registry](/using-plugins/plugin-registry) to register and execute plugin hooks.

## How hooks are executed

When a hook is triggered, the hook registry follows this execution flow:

1. All registered handlers for the hook type are collected.
2. Handlers are **sorted by priority** (ascending -- lower priority number executes first).
3. The **first handler** receives the original parameters.
4. Each **subsequent handler** receives the return value of the previous handler as its input.
5. After each handler executes, the result is checked for **signals** which are evaluated against [Act policies](/using-gatewayd/Act).
6. If any policy produces a **terminal action** (e.g., `terminate`), the hook chain is immediately stopped and the result is returned.
7. The final result of the last handler in the chain is returned to GatewayD.

## Error handling

- If a handler returns an **error**, the error is logged but execution continues with the next handler in the chain.
- If a handler returns **nil**, it is removed from the registry and the next handler continues with the previous result.

## Registration

Hooks are registered during plugin initialization. Each plugin declares the list of hooks it wants to handle, and the [plugin registry](/using-plugins/plugin-registry) maps each hook name to the corresponding gRPC method on the plugin at the plugin's assigned priority. The plugin's priority is determined by its position in the configuration file.

For the full list of available hooks and their types, see [hooks](/using-plugins/hooks).
