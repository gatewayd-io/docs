---
last_modified_date: 2023-08-01 12:29:40 +0200
layout: default
title: gRPC API Reference
description: GatewayD exposes a gRPC API that can be used to interact with the GatewayD plugin system. This API can be used by the GatewayD plugins and is available in the GatewayD SDK.
nav_order: 3
parent: Developing Plugins
---

# gRPC API Reference

GatewayD exposes a gRPC API that can be used to interact with the GatewayD plugin system. This API can be used by the GatewayD plugins and is available in the GatewayD SDK.

## Protocol buffers definition

The gRPC API v1 is defined in the [`plugin.proto`](https://github.com/gatewayd-io/gatewayd-plugin-sdk/blob/main/plugin/v1/plugin.proto) file. The gRPC API is versioned and the current version is v1.

## Go Stubs

The GatewayD SDK provides Go stubs for the gRPC API. The stubs are generated from the `plugin.proto`. The stubs are available in the [`plugin/v1`](https://github.com/gatewayd-io/gatewayd-plugin-sdk/tree/main/plugin/v1) package.

## Documentation

The latest gRPC API documentation is available [here](https://github.com/gatewayd-io/gatewayd-plugin-sdk/blob/main/plugin/v1/plugin.md).
