---
last_modified_date: 2024-04-16 08:43:06
layout: default
title: gatewayd-plugin-js
description: GatewayD plugin for running JS functions as hooks.
nav_order: 2
parent: Plugins
---

# gatewayd-plugin-js

The gatewayd-plugin-js is a GatewayD plugin for running JS functions as hooks and this is how it works:

1. Upon startup, the plugin creates a minimal JavaScript engine ([Goja](https://github.com/dop251/goja)) and registers helper functions for various tasks.
2. Then it loads all JS files in the directory specified by the `SCRIPT_PATH` environment variable. The environment variable must be set to the path of the file that contains the JS functions to be executed as hooks. It can also import other JS files from the same directory.
3. Based on the existing functions in the JS files, the plugin registers hooks for various events. If a function is not found for a particular event, the plugin does not register a hook for that event.
4. When an event is triggered and a hook function is called from GatewayD, the plugin executes the corresponding JS function and returns the result to the plugin and eventually to GatewayD.

{: .note }
> The functions receive a context and a request object as arguments and must return the same or the modified object. The `parseSQL` helper function can be used to parse SQL queries as stringified JSON objects.
>
> ```js
> function onTrafficFromClient(context, request) {
>   // Do something with the request object and return it
>   return request
> }
> ```

## Features

- Run JS functions as hooks
- Helper functions for common tasks such as parsing incoming queries
- Support for running multiple JS functions as hooks
- Prometheus metrics for monitoring
- Logging
- Configurable via environment variables and command-line arguments

## Installation

It is assumed that you have already installed PostgreSQL and [GatewayD](/getting-started/installation).

{: .note }
> The plugin is compatible with Linux, Windows and macOS.

### Automatic installation

The latest version of the plugin can be installed automatically by running the following command. This command downloads and installs the latest version of the plugin from [GitHub releases](https://github.com/gatewayd-io/gatewayd-plugin-js/releases) to the `plugins` directory in the current directory. The command will then enable the plugin automatically by copying the default [configuration](#configuration) to `gatewayd_plugins.yaml` from the project's GitHub repository.

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-js@latest
```

### Manual installation

1. Download and install the latest version of [gatewayd-plugin-js](https://github.com/gatewayd-io/gatewayd-plugin-js/releases/latest) by copying the binary to a directory that is in your `PATH` or accessible to GatewayD.
2. Copy the [configuration](#configuration) to [`gatewayd_plugins.yaml`](/using-gatewayd/plugins-configuration/plugins-configuration).
3. Make sure that the configuration parameters and environment variables are correct, particularly the `localPath`, `checksum` and the `SCRIPT_PATH`.

After installing the plugin using any of the above methods, you can start GatewayD and test the plugin by querying the database via GatewayD.

## Configuration

The plugin can be configured via environment variables or command-line arguments. For more information about other configuration parameters, see [plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration.md).

```yaml
plugins:
  - name: gatewayd-plugin-js
    enabled: True
    localPath: ../gatewayd-plugin-js/gatewayd-plugin-js
    args: ["--log-level", "info"]
    env:
      - MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN
      - MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872
      - SCRIPT_PATH=./scripts/index.js
      - SENTRY_DSN=https://439b580ade4a947cf16e5cfedd18f51f@o4504550475038720.ingest.sentry.io/4506475229413376
    checksum: d310772152467d9c6ab4ba17fd9dd40d3f724dee4aa014a722e1865d91744a4f
```

### Environment variables

| Name                 | Description                                                                  | Default                                                                                        |
| -------------------- | ---------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------- |
| `MAGIC_COOKIE_KEY`   | The key for the magic cookie.                                                | `GATEWAYD_PLUGIN`                                                                              |
| `MAGIC_COOKIE_VALUE` | The value for the magic cookie.                                              | `5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872`                             |
| `SCRIPT_PATH`        | The path to the JS file that contains the functions to be executed as hooks. | `./scripts/index.js`                                                                           |
| `SENTRY_DSN`         | Sentry DSN. Set to empty string to disable Sentry.                           | `https://439b580ade4a947cf16e5cfedd18f51f@o4504550475038720.ingest.sentry.io/4506475229413376` |

### Command-line arguments

| Name          | Description    | Default |
| ------------- | -------------- | ------- |
| `--log-level` | The log level. | `info`  |

## Build for testing

To build the plugin for development and testing, run the following command in the project's root directory after cloning the repository.

```bash
git clone git@github.com:gatewayd-io/gatewayd-plugin-js.git
cd gatewayd-plugin-js
make build-dev
```

Running the above commands clones the repository, changes the current directory and runs the `go mod tidy` and `go build` commands to compile and generate the plugin binary.
