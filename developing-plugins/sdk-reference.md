---
last_modified_date: 2024-04-16 15:01:00
layout: default
title: SDK Reference
description: The GatewayD plugin SDK provides a number of interfaces, structs and methods to help you build your plugin.
nav_order: 2
parent: Developing Plugins
---

# SDK Reference

The GatewayD plugin [SDK](https://github.com/gatewayd-io/gatewayd-plugin-sdk) provides a number of interfaces, structs and methods to help you build your plugin. This section provides a reference to all of them. The SDK is built for Go, but the protocol buffers definitions can be used to build plugins in other languages.

{: .warning }
> This documentation is not complete. Please refer to the [SDK source code](https://github.com/gatewayd-io/gatewayd-plugin-sdk) for more information. Also, it might be removed in the future in favor of [GoDoc](https://pkg.go.dev/github.com/gatewayd-io/gatewayd-plugin-sdk).

{: .wip }
> The SDK is still in development and [subject to change](https://github.com/gatewayd-io/gatewayd-plugin-sdk/issues).

## Packages

The root of the SDK is the `github.com/gatewayd-io/gatewayd-plugin-sdk`. It contains the following sub-packages:

### `config`

- `GetEnv` returns the value of an environment variable. If the environment variable is not set, it returns the default value as fallback.

    ```go
    func GetEnv(key, fallback string) string
    ```

### `databases/postgres`

- `IsPostgresStartupMessage` checks if a message is a Postgres startup message. It returns `true` if the message is a startup message, `false` otherwise.

    ```go
    func IsPostgresStartupMessage(message []byte) bool
    ```

- `DecodeBytes` decodes a base64 encoded string to bytes. It uses the `base64.StdEncoding` decoder. It returns the decoded bytes and an empty byte array if there is an error.

    ```go
    func DecodeBytes(encoded string) ([]byte, error)
    ```

- `HandleClientMessage` handles a client message. This function should be called from `onTrafficFromClient` hook. It returns a `v1.Struct` with extra fields that are decoded from the message. It logs the error and returns `nil` if there is an error.

    ```go
    func HandleClientMessage(req *v1.Struct, logger hclog.Logger) (*v1.Struct, error)
    ```

- `HandleServerMessage` handles a server message. This function should be called from `onTrafficFromServer` hook. It returns a `v1.Struct` with extra fields that are decoded from the message. It logs the error and returns `nil` if there is an error.

    ```go
    func HandleServerMessage(resp *v1.Struct, logger hclog.Logger) (*v1.Struct, error)
    ```

- `GetQueryFromRequest` decodes the request and returns the query. It returns an error if the request cannot be decoded. It returns an empty string if the query is not found.

    ```go
    func GetQueryFromRequest(req *v1.Struct) (string, error)
    ```

- `GetTablesFromQuery` returns the tables used in a query. It returns an error if the query cannot be parsed.

    ```go
    func GetTablesFromQuery(query string) ([]string, error)
    ```

### `logging`

- `GetLogLevel` returns the `hclog` level based on the (log level) string passed in.

    ```go
    func GetLogLevel(level string) hclog.Level
    ```

### `metrics`

- `NewMetricsConfig` returns a new `MetricsConfig` struct. It returns an error if the environment variables are not set. It returns `nil` if the metrics are disabled.

    ```go
    func NewMetricsConfig(config map[string]interface{}) *MetricsConfig
    ```

- `ExposeMetrics` exposes the Prometheus metrics via HTTP over Unix domain socket. It logs an error if the metrics cannot be exposed.

    ```go
    func ExposeMetrics(config *MetricsConfig, logger hclog.Logger) error
    ```

### `plugin`

- `DefaultGRPCServer` returns a gRPC server with a 2GB max message size.

    ```go
    func DefaultGRPCServer(opts []grpc.ServerOption) *grpc.Server
    ```

- `GetAttr` returns the value of an attribute from the `v1.Struct`. It returns the default value if the attribute is not found.

    ```go
    func GetAttr(req *v1.Struct, key string, defaultValue interface{}) interface{}
    ```

### `plugin/v1`

- `GetPluginMap` returns the plugin map for the plugin.

    ```go
    func GetPluginMap(pluginName string) map[string]goplugin.Plugin
    ```

- `GetPluginSetMap` returns the plugin set map for the plugin.

    ```go
    func GetPluginSetMap(plugins map[string]goplugin.Plugin) goplugin.PluginSet
    ```

- [`plugin.proto`](https://github.com/gatewayd-io/gatewayd-plugin-sdk/blob/main/plugin/v1/plugin.proto) is the protocol buffers definition for the plugin and its generated Go code stubs are in `plugin.pb.go` and `plugin_grpc.pb.go`.
- [`struct.proto`](https://github.com/gatewayd-io/gatewayd-plugin-sdk/blob/main/plugin/v1/struct.proto) is the protocol buffers definition for the `v1.Struct` and its generated Go code stubs are in `struct.pb.go` and `structpb.go`. This is a modified version of the `Struct` from the [Google Protobuf](https://github.com/protocolbuffers/protobuf/blob/main/src/google/protobuf/struct.proto) library with an additional `bytes` field.
