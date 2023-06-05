---
layout: default
title: Installation
nav_order: 3
parent: Getting Started
---

# Installation

GatewayD binaries are currently available for Linux and macOS.

{: .wip }
> Support for the [Docker image](https://github.com/gatewayd-io/gatewayd/issues/137) are in the works.

## Installing GatewayD

All GatewayD [releases](https://github.com/gatewayd-io/gatewayd/releases) are available in the [GitHub repository](https://github.com/gatewayd-io/gatewayd) as standalone binaries for Linux and macOS platforms.

### Binary releases

Download and extract the archive for your platform, then place the `gatewayd` binary in your `PATH` to run it from any location. The [`gatewayd.yaml`](../using-gatewayd/configuration#global-configuration) and [`gatewayd_plugins.yaml`](../using-gatewayd/configuration#plugins-configuration) configuration files are located next to the gatewayd binary in the downloaded archive. These are the default global and plugins configuration files for GatewayD.

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/v0.6.7/gatewayd-linux-amd64-v0.6.7.tar.gz | tar xvf -
```

### APT and RPM packages

Alternatively, GatewayD is available as APT and RPM packages for Linux distributions. These packages include the `gatewayd` binary and the default global and plugins configuration files. The `gatewayd` binary will be installed in `/usr/bin/gatewayd` and the configuration files will be installed in `/etc` as `/etc/gatewayd.yaml` and `/etc/gatewayd_plugins.yaml`.

### Install APT package

Download the `.deb` package and install it using `dpkg`:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/v0.6.7/gatewayd_0.6.7_amd64.deb -o gatewayd_0.6.7_amd64.deb
sudo dpkg -i gatewayd_0.6.7_amd64.deb
```

### Install RPM package

Download the `.rpm` package and install it using `rpm`:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/v0.6.7/gatewayd-0.6.7.x86_64.rpm -o gatewayd-0.6.7.x86_64.rpm
sudo rpm -i gatewayd-0.6.7.x86_64.rpm
```

## Installing plugins

To use GatewayD plugins, you need to download and extract them, and place them in your desired location that is accessible to GatewayD via the plugins configuration file, aka. `gatewayd_plugins.yaml`.

For more information about plugins, please refer to the [plugins configuration](../using-gatewayd/plugins-configuration/plugins-configuration) and the [plugins](../using-plugins/plugins) page.

{: .wip }
> A [`plugin` subcommand](https://github.com/gatewayd-io/gatewayd/issues/122) is in the works to simplify installation and management of plugins and their configurations.

## Building GatewayD from source
