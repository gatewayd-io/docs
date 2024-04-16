---
last_modified_date: 2024-04-16 08:43:06
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

For Linux-based distributions, you can use the following commands to download and extract the archive:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-linux-amd64-{% github_latest_release gatewayd-io/gatewayd %}.tar.gz | tar zxvf -
```

For macOS, you can use the following commands to download and extract the archive:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-darwin-amd64-{% github_latest_release gatewayd-io/gatewayd %}.tar.gz | tar zxvf -
```

For Windows, you can use the following commands to download and extract the archive:

```bash
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip -o gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip
unzip gatewayd-windows-amd64-{% github_latest_release gatewayd-io/gatewayd %}.zip -d gatewayd
```

{: .note }
> Note that the above commands download the latest release of GatewayD for `amd64` architecture. To download the latest (or a specific) release of GatewayD for `arm64` architecture, replace `amd64` with `arm64` in the above commands and replace the version number in the URL with the desired version number. It is always recommended to use the latest release of GatewayD and its plugins.

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
curl -L https://github.com/gatewayd-io/gatewayd/releases/download/{% github_latest_release gatewayd-io/gatewayd %}/gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}-1.x86_64.rpm -o gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}-1.x86_64.rpm
sudo rpm -i gatewayd-{% github_latest_release gatewayd-io/gatewayd v %}-1.x86_64.rpm
```

### Docker image

GatewayD is also available as a Docker image. The image is available on [Docker Hub](https://hub.docker.com/r/gatewaydio/gatewayd) and [GitHub Container Registry](https://ghcr.io/gatewayd-io/gatewayd:latest).

To run GatewayD using Docker, you can use the following command, considering that the `gatewayd.yaml` and `gatewayd_plugins.yaml` configuration files and plugins are located in the current working directory on the host machine. The server will be available on port `15432` on the host machine and the container will be removed after it exits.

```bash
docker run -v ./:/opt -p 15432:15432 --rm gatewaydio/gatewayd:latest run --config /opt/gatewayd.yaml --plugins-config /opt/gatewayd_plugins.yaml
```

The same image can be used to install plugins. The plugins will be installed in the `plugins` directory in the current working directory on the host machine.

```bash
docker run -v ./:/opt --rm gatewaydio/gatewayd:latest plugin install github.com/<organization>/<plugin-name>@<version> --plugins-config /opt/gatewayd_plugins.yaml
```

{: .note }
> In the above examples, the image from Docker Hub is used. To use the image from GitHub Container Registry, replace `gatewaydio/gatewayd:latest` with `ghcr.io/gatewayd-io/gatewayd:latest`.

### Docker Compose

For ease of use, a [docker-compose](https://github.com/gatewayd-io/gatewayd/blob/main/docker-compose.yaml) file and a [setup.sh](https://github.com/gatewayd-io/gatewayd/blob/main/setup.sh) are available, which starts a few services to demonstrate the capabilities of GatewayD. This is a good starting point to test GatewayD and its plugins.

#### Download and run the docker-compose file

To download and run the docker-compose and the setup files, use the following commands:

```bash
# Create a new directory and navigate to it
mkdir gatewayd && cd gatewayd
# Download the docker-compose file and the setup script
curl -L https://raw.githubusercontent.com/gatewayd-io/gatewayd/main/docker-compose.yaml -o docker-compose.yaml
curl -L https://raw.githubusercontent.com/gatewayd-io/gatewayd/main/setup.sh -o setup.sh
# Run the docker-compose file
docker-compose up -d
```

The above commands will download the `docker-compose.yaml` file and the `setup.sh` script from the GitHub repository and start the services. The `setup.sh` script will install the cache plugin and update the `gatewayd_plugins.yaml` configuration file. The `docker-compose.yaml` file will start the services the following services:

1. A transient service that installs the cache plugin
2. PostgreSQL database
3. Redis
4. GatewayD with the cache plugin

#### Exposed ports and services

GatewayD will expose a few ports that will be available on the host machine. The ports are one-to-one mapped to the container's ports.

| Port  | Service Name          | Endpoints/Services/Protocols                                                                                                                          | Description                                                                                                                                                                                         |
| ----- | --------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 15432 | GatewayD server       | [Postgres Wire Protocol](https://www.postgresql.org/docs/current/protocol.html)                                                                       | GatewayD server for PostgreSQL clients to connect to                                                                                                                                                |
| 9090  | Prometheus metrics    | <http://localhost:9090/metrics>                                                                                                                       | Prometheus metrics                                                                                                                                                                                  |
| 18080 | GatewayD HTTP gateway | <http://localhost:18080/swagger-ui/><br/><http://localhost:18080/healthz>                                                                             | API documentation and health check                                                                                                                                                                  |
| 19090 | GatewayD gRPC API     | `api.v1.GatewayDAdminAPIService`<br/>`grpc.health.v1.Health`<br/>`grpc.reflection.v1.ServerReflection`<br/>`grpc.reflection.v1alpha.ServerReflection` | gRPC API with reflection enabled. Use [grpcurl](https://github.com/fullstorydev/grpcurl), [grpc-client-cli](https://github.com/vadimi/grpc-client-cli) or any other gRPC client to interact with it |

#### Test the services

To test the services, you can use the following commands:

```bash
docker exec -it postgres-test psql postgresql://postgres:postgres@${DOCKER_HOST}:5432/postgres -c "\d"
```

Since the database is just created, no relations exist, which is expected. You can change the configuration of the services in the `gatewayd.yaml` and `gatewayd_plugins.yaml` configuration files inside the `gatewayd-files` directory.

#### Stop and remove the services

To stop and remove the services, use the following command:

```bash
docker-compose down
```

## Installing plugins

Plugins are available as standalone binaries for different platforms. These binaries are available in their GitHub repositories and are distributed as archives that contain the binary and the default configuration file for the plugin. The README file and the LICENSE file might also be included in the archive.

There are currently four ways to install plugins using the `gatewayd plugin install` subcommand:

1. Providing the plugins configuration file with the plugins' URLs and versions.
2. Using the GitHub URL of the plugin plus the version.
3. Using the already downloaded archive of the plugin.
4. Manually downloading, extracting and placing the plugins' binaries in your desired location and updating the plugins configuration file.

### 1. Using the plugins configuration file

In the `gatewayd_plugins.yaml` configuration file, you can specify the URLs and versions of the plugins that you want to install. The `gatewayd plugin install` subcommand will download the archives of the plugins from the specified URLs and extract them to the `plugins` directory in the current working directory and will also update the `gatewayd_plugins.yaml` configuration file.

```bash
gatewayd plugin install
```

### 2. Using the GitHub URL of the plugin plus the version

You can also install plugins using the GitHub URL of the plugin plus the version. The `gatewayd plugin install` subcommand will download the archive of the plugin from the specified URL and extract it to the `plugins` directory in the current working directory.

```bash
gatewayd plugin install github.com/<organization>/<plugin-name>@<version>
```

For example, to install the `gatewayd-plugin-cache` plugin:

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-cache@latest
```

You can also specify that you want to pull only and you don't want to extract the archive of the plugin.

```bash
gatewayd plugin install --pull-only github.com/gatewayd-io/gatewayd-plugin-cache@latest
```

### 3. Using the already downloaded archive of the plugin

You can also install plugins using the already downloaded archive of the plugin or using the `--pull-only` flag explained above. The `gatewayd plugin install` subcommand will extract the archive of the plugin to the `plugins` directory in the current working directory. The `--name` flag is mandatory when using this method and it must be the same as the name of the plugin.

```bash
gatewayd plugin install --name <plugin-name> <path-to-archive>
```

### 4. Manually downloading, extracting and placing the plugins' binaries in your desired location

You can manually download, extract and place the plugins' binaries in your desired location that is accessible to GatewayD via the plugins configuration file, aka. `gatewayd_plugins.yaml`. Then you must update the plugins configuration file with the desired plugin's configuration that is available in the plugin's repository as `gatewayd_plugin.yaml` (or inside the archive file of the plugin). Checksum files are also available in the plugin's repository as release assets and also inside the archive file of the plugin.

For more flags, please refer to the [CLI](/using-gatewayd/CLI) page or just run `gatewayd plugin install --help`.

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
