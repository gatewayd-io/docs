---
last_modified_date: 2023-09-02 22:22:23 +0200
layout: default
title: Plugin Developers Guide
description: Plugin developers' guide of GatewayD
nav_order: 1
parent: Developing Plugins
---

# Plugin Developers Guide

The usage of plugin from the user perspective is described [here](/using-plugins/plugins), which will give you a good overview of how plugins work. The [lifecycle](/using-plugins/plugins#lifecycle) of a plugin is described on the same page. This page is a guide for plugin developers.

## Overview

Follow these steps to create a plugin:

1. Use the [GatewayD plugin template for Go](https://github.com/gatewayd-io/plugin-template-go) repository to create a new repository for your plugin.
2. Clone the repository and start developing your plugin.
3. Update the `gatewayd_plugins.yml` file with the correct information.
4. Test your plugin locally using the `make run` target of GatewayD.
5. Test your plugin in the CI pipeline.
6. Test your plugin using this [`test.yaml`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/.github/workflows/test.yaml) workflow.
7. Publish your plugin to GitHub using this [`release.yaml`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/.github/workflows/release.yaml) workflow and this [`Makefile`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/Makefile).
8. Publish your plugin.

{: .note }
> You can also use the [GatewayD plugin template for Python](https://github.com/gatewayd-io/plugin-template-python) repository to create a new repository for your plugin. The project is not as mature as the Go template and might have some rough edges.

In the following sections, each step is described in more detail.

## Step 1: Use the GatewayD plugin template

The [GatewayD plugin template for Go](https://github.com/gatewayd-io/plugin-template-go) repository contains a template for a plugin. You can use this template to create a new repository for your plugin. As a concrete example, the [cache plugin](https://github.com/gatewayd-io/gatewayd-plugin-cache) contains a `Makefile` and a GitHub workflow to test and release your plugin.

You can always start from scratch, but it is recommended to use the template to get started quickly.

This is the structure of the template:

```bash
.
├── gatewayd_plugin.yaml # Metadata
├── go.mod # Dependencies
├── go.sum
├── LICENSE
├── main.go # The main function that starts your plugin
├── Makefile # Targets to build the plugin, create checksum and update dependencies
├── plugin # Source code of your plugin
│   ├── metrics.go # Prometheus metrics
│   ├── module.go # Plugin module: plugin ID, plugin map and plugin config
│   └── plugin.go # The actual implementation of your plugin
├── plugin-template-go # Generated plugin binary
└── README.md # Documentation
```

## Step 2: Clone the repository and start developing your plugin

After you have created a new repository for your plugin, clone it and start developing your plugin. The template contains a `Makefile` with targets to build the plugin, create checksum and update dependencies. You can use these targets to build your plugin.

## Step 3: Update the `gatewayd_plugins.yml` file with the correct information

The `gatewayd_plugins.yml` file contains the metadata of your plugin. This file is used by GatewayD to load your plugin. The following fields are required:

- `name`: The name of your plugin.
- `enabled`: Whether the plugin is enabled or not.
- `localPath`: The path to the plugin binary.
- `env`: The environment variables that are passed to the plugin.

The following fields are optional:

- `args`: The arguments that are passed to the plugin.
- `checksum`: The checksum of the plugin binary.

These two environment variables with their exact values are required. They must be passed to the [HandshakeConfig](https://github.com/gatewayd-io/plugin-template-go/blob/c103e739467a9814086508e1e8257871c00932e4/main.go#L44-L45) of the plugin. These pieces of information are used by GatewayD to verify and load the plugin:

- `MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN`
- `MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872`

## Step 4: Test your plugin locally using the `make run` target of GatewayD

You can test your plugin locally by running GatewayD CLI in development mode. The development mode lets your test your plugin without checksum verification. For more information, see GatewayD [CLI](/using-gatewayd/CLI).

- Install GatewayD according to the [installation](/getting-started/installation) instructions.
- Run the following command to start GatewayD CLI in development mode:

```bash
./gatewayd run --dev
```

{: .note }
> It is recommended to use the `trace` log level to see the logs of your plugin. For more information, see [loggers](/using-gatewayd/global-configuration/loggers).

## Step 5: Test your plugin in the CI pipeline

Copy the [`test-plugin`](https://github.com/gatewayd-io/gatewayd/blob/213ba09fbf20f0b3923d246d4320dab46fdf8be3/.github/workflows/test.yaml#L61-L144) job of the GatewayD CI pipeline into the `.github/workflows/test.yaml` file. This job will test your plugin using the [GatewayD CLI](/using-gatewayd/CLI) in development mode.

## Step 6: Test your plugin using this `test.yaml` workflow

If you have written tests for your plugin, you can use the following workflow to test your plugin. Copy the [`test.yaml`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/.github/workflows/test.yaml) workflow into the `.github/workflows/` directory of your plugin. This workflow will test your plugin using the [GatewayD CLI](/using-gatewayd/CLI) in development mode.

## Step 7: Publish your plugin to GitHub using this `release.yaml` workflow and this `Makefile`

If you want to publish your plugin to GitHub, you can use the following workflow and `Makefile` to release your plugin. Copy the [`release.yaml`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/.github/workflows/release.yaml) workflow and this [`Makefile`](https://github.com/gatewayd-io/gatewayd-plugin-cache/blob/main/Makefile) into the `.github/workflows/` and the root directory of your plugin. This workflow will release your plugin to GitHub.

{: .note }
> You must modify the example `Makefile`, `release.yaml` and `test.yaml` files to match your plugin.

## Step 8: Publish your plugin

If you want GatewayD to install your plugin from GitHub, you must adhere to the following rules:

1. The plugin binary must be named as the repository name, aka. the plugin name.
2. The plugin binary must be placed in the root directory of the release asset.
3. The checksums should be generated using sha256sum, published as release assets and named `checksums.txt`.
4. The release assets must be published as `tar.gz` archives.
5. The release assets must follow the naming convention: `plugin-name-$GOOS-$GOARCH-version.tar.gz`.
6. The releases must follow semantic versioning and prefixed with `v`.
7. The `latest` release must point to the latest release, otherwise the plugin will not be installed if the version is not specified.

<!-- ## Step 9: Publish your plugin to the GatewayD plugin registry

We have plans to create a plugin registry for GatewayD. Until then, you can publish your plugin on GitHub. -->

## Next steps

Check out the [using plugins](/using-plugins/plugins) page to know more about the details of the plugin system including hooks, plugin registry, hook registry and different plugin types.
