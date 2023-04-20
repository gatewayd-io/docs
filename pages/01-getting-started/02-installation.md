# Installation

GatewayD binaries are currently available for Linux and macOS.

> **🚧 Work in Progress**
>
> Support for [packages for different distribution](https://github.com/gatewayd-io/gatewayd/issues/136) and the [Docker image](https://github.com/gatewayd-io/gatewayd/issues/137) is in the works.

## Downloading the GatewayD binary

All GatewayD [releases](https://github.com/gatewayd-io/gatewayd/releases) are available in the [GitHub repository](https://github.com/gatewayd-io/gatewayd) as standalone binaries for Linux and macOS platforms. Download and extract the archive for your platform, then place the `gatewayd` binary in your `PATH` to run it from any location. The [`gatewayd.yaml`](../02-using-gatewayd/01-configuration/index.md#global-configuration) and [`gatewayd_plugins.yaml`](../02-using-gatewayd/01-configuration/index.md#plugins-configuration) configuration files are located next to the gatewayd binary in the downloaded archive. These are the default global and plugins configuration files for GatewayD.

## Using GatewayD plugins

If you want to use GatewayD plugins, you will need to download and extract them, and place them in your desired location that is accessible to GatewayD.

For more information about plugins, please refer to the [plugins configuration](../02-using-gatewayd/01-configuration/02-plugins-configuration/02-plugins-configuration.md) and the [plugins](../03-using-plugins/01-plugins.md) page.

> **🚧 Work in Progress**
>
> A [`plugin` subcommand](https://github.com/gatewayd-io/gatewayd/issues/122) is in the works to simplify installation and management of plugins and their configurations.
