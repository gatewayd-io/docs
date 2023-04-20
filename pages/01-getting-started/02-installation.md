# Installation

GatewayD binaries are released for Linux and macOS.

> **🚧 Work in Progress**
>
> Support for [packages for different distribution](https://github.com/gatewayd-io/gatewayd/issues/136) and the [Docker image](https://github.com/gatewayd-io/gatewayd/issues/137) is in the works.

## Download the GatewayD binary

The GatewayD [repository](https://github.com/gatewayd-io/gatewayd) on GitHub contains all the [releases](https://github.com/gatewayd-io/gatewayd/releases) as a standalone binaries for Linux and macOS platforms, from which you can download and extract the archive for your platform. After that, you can place the `gatewayd` binary in your `PATH` to run it from any location. the `gatewayd.yaml` and `gatewayd_plugins.yaml` configurations files exist next to the `gatewayd` binary in the downloaded archive. Those are the default [global](../02-using-gatewayd/01-configuration/index.md#global-configuration) and [plugins](../02-using-gatewayd/01-configuration/index.md#plugins-configuration) configuration files for GatewayD.

## Using GatewayD plugins

If you want to use GatewayD plugins, you need to download, extract and place them in your desired location, accessible to GatewayD.

For more information about plugins, see the [plugins configuration](../02-using-gatewayd/01-configuration/02-plugins-configuration/02-plugins-configuration.md) and the [plugins](../03-using-plugins/01-plugins.md) page.

> **🚧 Work in Progress**
>
> A [`plugin` subcommand](https://github.com/gatewayd-io/gatewayd/issues/122) is in the works to simplify installation and management of plugins and their configurations.
