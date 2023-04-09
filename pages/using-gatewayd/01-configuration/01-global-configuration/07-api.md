# API

GatewayD exposes a gRPC API with an HTTP gateway for managing the `gatewayd` process and its plugins. The API is currently used by plugins to query the `gatewayd` process for runtime configuration.

**🗒️ Note**
Currently the API is in beta and [subject to change](https://github.com/gatewayd-io/gatewayd/issues/181).

## Configuration parameters

| Name        | Type    | Default value   | Possible values | Description                                                                    |
| ----------- | ------- | --------------- | --------------- | ------------------------------------------------------------------------------ |
| enabled     | boolean | True            | True, False     | Enable or disable the API. Disabling the API might cause some plugins to fail. |
| httpAddress | string  | localhost:18080 | Valid host:port | The address to listen on for HTTP requests.                                    |
| grpcNetwork | string  | tcp             | tcp, unix       | The network to listen on for gRPC requests.                                    |
| grpcAddress | string  | localhost:19090 | Valid host:port | The address to listen on for gRPC requests.                                    |

**🗒️ Note**
If you change the default values for `httpAddress` or `grpcAddress`, you must also update the plugin configuration to reflect the new values.

## Example configuration

```yaml
api:
  enabled: True
  httpAddress: localhost:18080
  grpcNetwork: tcp
  grpcAddress: localhost:19090
```
