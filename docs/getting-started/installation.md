---
layout: default
title: Installation
nav_order: 3
parent: Getting Started
---

# Installation

GatewayD binaries are currently available for Linux and macOS.

{: .wip }
> Support for [packages for different distribution](https://github.com/gatewayd-io/gatewayd/issues/136) and the [Docker image](https://github.com/gatewayd-io/gatewayd/issues/137) is in the works.

## Downloading the GatewayD binary

All GatewayD [releases](https://github.com/gatewayd-io/gatewayd/releases) are available in the [GitHub repository](https://github.com/gatewayd-io/gatewayd) as standalone binaries for Linux and macOS platforms. Download and extract the archive for your platform, then place the `gatewayd` binary in your `PATH` to run it from any location. The [`gatewayd.yaml`](../using-gatewayd/configuration#global-configuration) and [`gatewayd_plugins.yaml`](../using-gatewayd/configuration#plugins-configuration) configuration files are located next to the gatewayd binary in the downloaded archive. These are the default global and plugins configuration files for GatewayD.

## Using GatewayD plugins

If you want to use GatewayD plugins, you will need to download and extract them, and place them in your desired location that is accessible to GatewayD.

For more information about plugins, please refer to the [plugins configuration](../using-gatewayd/plugins-configuration/plugins-configuration) and the [plugins](../using-plugins/plugins) page.

{: .wip }
> A [`plugin` subcommand](https://github.com/gatewayd-io/gatewayd/issues/122) is in the works to simplify installation and management of plugins and their configurations.