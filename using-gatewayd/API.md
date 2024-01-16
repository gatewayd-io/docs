---
last_modified_date: 2024-01-01 13:14:21 +0100
layout: default
title: API
description: GatewayD exposes a gRPC API with an HTTP gateway for querying and managing the `gatewayd` process and its plugins.
nav_order: 9
parent: Using GatewayD
---

# API

{: .warning }
> Currently the API is WIP and [subject to change](https://github.com/gatewayd-io/gatewayd/issues/181).

GatewayD exposes a gRPC API with an HTTP gateway for querying and managing the `gatewayd` process and its plugins. The API is currently used by plugins to query the `gatewayd` process for runtime configuration. The API can be configured via the [global configuration file](/using-gatewayd/global-configuration/api).

## gRPC API

The gRPC API uses protocol buffers, which is defined in the [`api.proto`](https://github.com/gatewayd-io/gatewayd/blob/main/api/v1/api.proto) file.

## HTTP Gateway

The HTTP gateway is generated from the gRPC API using [grpc-gateway](https://github.com/grpc-ecosystem/grpc-gateway) and exposes the same endpoints as the gRPC API. The Swagger API definition can be found [here](https://github.com/gatewayd-io/gatewayd/blob/main/api/v1/api.swagger.json). The Swagger UI is available at `/swagger-ui/`, which serves the Swagger file at `/swagger.json`.

## Endpoints

The API exposes the following endpoints on the gRPC server and HTTP gateway:

| gRPC Endpoint                                     | HTTP Gateway Endpoint                       | Description                                 |
| ------------------------------------------------- | ------------------------------------------- | ------------------------------------------- |
| `/api.v1.GatewayDAdminAPIService/Version`         | `/v1/GatewayDPluginService/Version`         | Returns the version information of GatewayD |
| `/api.v1.GatewayDAdminAPIService/GetGlobalConfig` | `/v1/GatewayDPluginService/GetGlobalConfig` | Returns the loaded global configuration     |
| `/api.v1.GatewayDAdminAPIService/GetPluginConfig` | `/v1/GatewayDPluginService/GetPluginConfig` | Returns the loaded plugins configuration    |
| `/api.v1.GatewayDAdminAPIService/GetPlugins`      | `/v1/GatewayDPluginService/GetPlugins`      | Returns the list of plugins loaded          |
| `/api.v1.GatewayDAdminAPIService/GetPools`        | `/v1/GatewayDPluginService/GetPools`        | Returns the list of active pools            |
| `/api.v1.GatewayDAdminAPIService/GetProxies`      | `/v1/GatewayDPluginService/GetProxies`      | Returns the list of active proxies          |
| `/api.v1.GatewayDAdminAPIService/GetServers`      | `/v1/GatewayDPluginService/GetServers`      | Returns the list of active servers          |

## Liveness and Readiness

The gRPC server and the HTTP gateway exposes the health endpoints for liveness and readiness probes in containerized environments and kubernetes. All the probes return whether all the servers are running or not. The health check works both on the gRPC server and the HTTP server and can be tested using the following commands:

```bash
# gRPC server
$ grpc-client-cli health localhost:19090
{
 "status":  "SERVING"
}
# HTTP gateway
$ curl http://localhost:18080/healthz
{"status":"SERVING"}
```
