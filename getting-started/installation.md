---
last_modified_date: 2023-09-24 23:36:49 +0200
layout: default
title: Installation
description: How to install GatewayD and its plugins on different platforms and how to build it from source.
nav_order: 3
parent: Getting Started
---

# Installation

GatewayD binaries are currently available for Windows, Linux-based distributions and macOS. It is also available as a Docker image.

## Installing GatewayD

All GatewayD [releases](https://github.com/gatewayd-io/gatewayd/releases) are available in the [GitHub repository](https://github.com/gatewayd-io/gatewayd) as standalone binaries for Linux and macOS platforms.

### Binary releases

GatewayD releases are available as standalone binaries for Linux, Windows and macOS platforms.

Download and extract the archive for your platform, then place the `gatewayd(.exe)` binary in your `PATH` to run it from any location. The [`gatewayd.yaml`](/using-gatewayd/configuration#global-configuration) and [`gatewayd_plugins.yaml`](/using-gatewayd/configuration#plugins-configuration) configuration files are located next to the gatewayd binary in the downloaded archive. These are the default global and plugins configuration files for GatewayD. Extract them to your desired location and use them as a starting point for your configuration.

For Unix-like systems, you can use the following commands to download and extract the archive:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-linux-amd64-{% github_latest_release gatewayd-io/gatewayd %}.tar.gz | tar xvf -
```

For Windows, you can use the following commands to download and extract the archive:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip -o gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip
unzip gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip -d gatewayd
```

### APT and RPM packages

Alternatively, GatewayD is available as APT and RPM packages for Linux distributions. These packages include the `gatewayd` binary and the default global and plugins configuration files. The `gatewayd` binary will be installed in `/usr/bin/gatewayd` and the configuration files will be installed in `/etc` as `/etc/gatewayd.yaml` and `/etc/gatewayd_plugins.yaml`.

### Install APT package

Download the `.deb` package and install it using `dpkg`:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd_{% github_latest_release gatewayd-io/gatewayd v %}_amd64.deb -o gatewayd_{% github_latest_release gatewayd-io/gatewayd v %}_amd64.deb
sudo dpkg -i gatewayd_{% github_latest_release gatewayd-io/gatewayd v %}_amd64.deb
```

### Install RPM package

Download the `.rpm` package and install it using `rpm`:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}.x86_64.rpm -o gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}.x86_64.rpm
sudo rpm -i gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}.x86_64.rpm
```

### Docker image

GatewayD is also available as a Docker image. The image is available on [GitHub Container Registry](https://ghcr.io/gatewayd-io/gatewayd:latest) and [Docker Hub](https://hub.docker.com/r/gatewaydio/gatewayd).

To run GatewayD using Docker, you can use the following command, considering that the `gatewayd.yaml` and `gatewayd_plugins.yaml` configuration files and plugins are located in the current working directory on the host machine. The server will be available on port `15432` on the host machine and the container will be removed after it exits.

```bash
docker run -v ./:/opt -p 15432:15432 --rm ghcr.io/gatewayd-io/gatewayd:latest run --config /opt/gatewayd.yaml --plugins-config /opt/gatewayd_plugins.yaml
```

The same image can be used to install plugins. The plugins will be installed in the `plugins` directory in the current working directory on the host machine.

```bash
docker run -v ./:/opt --rm ghcr.io/gatewayd-io/gatewayd:latest plugin install github.com/<organization>/<plugin-name>@<version> --plugins-config /opt/gatewayd_plugins.yaml
```

{: .note }
> In the above examples, the image from GitHub Container Registry is used. To use the image from Docker Hub, replace `ghcr.io/gatewayd-io/gatewayd:latest` with `gatewaydio/gatewayd:latest`.

### Docker Compose

For ease of use, a [docker-compose](https://github.com/gatewayd-io/gatewayd/blob/main/docker-compose.yaml) file is available. It starts two services: a PostgreSQL database and GatewayD. The server will be available on port `15432` on the host machine.

```bash
curl -L https://raw.githubusercontent.com/gatewayd-io/gatewayd/main/docker-compose.yaml -o docker-compose.yaml
docker-compose up -d
```

## Installing plugins

Plugins are available as standalone binaries for different platforms. These binaries are available in their GitHub repositories.

The plugins can be installed by using the `plugin` subcommand of `gatewayd`:

```bash
gatewayd plugin install github.com/<organization>/<plugin-name>@<version>
```

For example, to install the `gatewayd-plugin-cache` plugin:

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-cache@latest
```

The plugin binary will be installed in the `plugins` directory in the current working directory. For more flags, please refer to the [CLI](/using-gatewayd/CLI) page or just run `gatewayd plugin install --help`.

Alternatively you can manually download, extract and place the plugins' binaries in your desired location that is accessible to GatewayD via the plugins configuration file, aka. `gatewayd_plugins.yaml`.

For more information about plugins, please refer to the [plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration) and the [plugins](/using-plugins/plugins) page.

## Building GatewayD from source

To build GatewayD from source, you need to have [Go](https://golang.org/doc/install) installed on your system. GatewayD is built and tested with Go 1.20.

```bash
git clone git@github.com:gatewayd-io/gatewayd.git
cd gatewayd
make build-dev
```

The `gatewayd` binary will be built in the `gatewayd` (root) directory. You can run it from there.

```bash
./gatewayd run --dev
```

Alternatively, you can run it using `make`, which uses `go run` to run GatewayD:

```bash
make run
```
