---
last_modified_date: 2026-02-16 23:47:00
layout: default
title: gatewayd-plugin-auth
description: GatewayD plugin for authentication, authorization, and access control.
nav_order: 3
parent: Plugins
---

# gatewayd-plugin-auth

The `gatewayd-plugin-auth` is a GatewayD plugin for authentication, authorization, and access control. It acts as an identity broker between PostgreSQL clients and backend databases, handling authentication at the proxy layer. This is how it works:

1. When a client connects to GatewayD, the plugin intercepts the startup message and extracts the username and target database.
2. The plugin looks up the user in a YAML-based credential store and validates database access permissions.
3. Depending on the configured authentication method, the plugin sends the appropriate authentication challenge (cleartext, MD5, or SCRAM-SHA-256) to the client.
4. The client responds with password or SASL data, and the plugin validates the credentials against the credential store.
5. If the credentials are valid, the plugin sends an `AuthenticationOk` message to the client and allows the connection to proceed. Otherwise, it sends an error and terminates the connection.
6. After authentication, if authorization is enabled, the plugin optionally checks each SQL query against a Casbin RBAC policy to enforce table-level access control.

## Features

- **Multiple authentication methods**:
  - **Cleartext**: Direct password comparison
  - **MD5**: Per-connection salt, MD5 hash validation
  - **SCRAM-SHA-256**: Multi-round SASL handshake
- Per-user authentication method restrictions
- Per-user database access control
- User enable/disable capability
- YAML-based credential management with per-user settings
- Optional Casbin-based RBAC query authorization with table-level access control
- Per-connection session management with TTL-based cleanup
- Prometheus metrics for authentication successes, failures, authorization denials, and active sessions
- Prometheus metrics for counting total RPC method calls
- Sentry integration for error tracking (optional)
- Logging
- Configurable via environment variables

## Installation

It is assumed that you have already installed PostgreSQL and [GatewayD](/getting-started/installation).

{: .note }
> The plugin is compatible with Linux, Windows and macOS.

### Automatic installation

The latest version of the plugin can be installed automatically by running the following command. This command downloads and installs the latest version of the plugin from [GitHub releases](https://github.com/gatewayd-io/gatewayd-plugin-auth/releases) to the `plugins` directory in the current directory. The command will then enable the plugin automatically by copying the default [configuration](#configuration) to `gatewayd_plugins.yaml` from the project's GitHub repository.

```bash
gatewayd plugin install github.com/gatewayd-io/gatewayd-plugin-auth@latest
```

### Manual installation

1. Download and install the latest version of [gatewayd-plugin-auth](https://github.com/gatewayd-io/gatewayd-plugin-auth/releases/latest) by copying the binary to a directory that is in your `PATH` or accessible to GatewayD.
2. Copy the [configuration](#configuration) to [`gatewayd_plugins.yaml`](/using-gatewayd/plugins-configuration/plugins-configuration).
3. Make sure that the configuration parameters and environment variables are correct, particularly the `localPath`, `checksum`, `AUTH_TYPE` and `CREDENTIALS_FILE`.
4. Create a `credentials.yaml` file based on the [credentials example](#credentials-file) and configure users and passwords.

After installing the plugin using any of the above methods, you can start GatewayD and test the plugin by connecting to the database via GatewayD using one of the configured users.

## Configuration

The plugin can be configured via environment variables or command-line arguments. For more information about other configuration parameters, see [plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration.md).

```yaml
plugins:
  - name: gatewayd-plugin-auth
    enabled: True
    localPath: ../gatewayd-plugin-auth/gatewayd-plugin-auth
    url: github.com/gatewayd-io/gatewayd-plugin-auth@latest
    args: ["--log-level", "info"]
    env:
      - MAGIC_COOKIE_KEY=GATEWAYD_PLUGIN
      - MAGIC_COOKIE_VALUE=5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872
      - AUTH_TYPE=md5
      - CREDENTIALS_FILE=./credentials.yaml
      - SERVER_VERSION=17.4
      - METRICS_ENABLED=True
      - METRICS_UNIX_DOMAIN_SOCKET=/tmp/gatewayd-plugin-auth.sock
      - METRICS_PATH=/metrics
      # Optional authorization:
      # - AUTHORIZATION_ENABLED=true
      # - CASBIN_MODEL_PATH=./model.conf
      # - CASBIN_POLICY_PATH=./policy.csv
      - SENTRY_DSN=https://e9b154400dd9dc7b40c1af839dc4935e@o4504550475038720.ingest.us.sentry.io/4510898014519296
    checksum: <checksum>
```

### Credentials file

The plugin uses a YAML file to store user credentials. Below is an example `credentials.yaml` file:

```yaml
users:
  - username: alice
    password: "s3cret_alice"
    auth_methods: ["scram-sha-256", "md5", "cleartext"]
    roles: ["admin"]
    databases: ["mydb", "analytics"]
    enabled: true

  - username: bob
    password: "b0b_password"
    auth_methods: ["md5"]
    roles: ["readonly"]
    databases: ["mydb"]
    enabled: true

  - username: service_account
    password: "svc_p@ss"
    auth_methods: ["md5", "cleartext"]
    roles: ["readwrite"]
    databases: []  # empty = all databases
    enabled: true
```

Each user entry supports the following fields:

| Field          | Description                                                                                 | Required |
| -------------- | ------------------------------------------------------------------------------------------- | -------- |
| `username`     | The username for the client to authenticate with.                                           | Yes      |
| `password`     | The plaintext password for the user.                                                        | Yes      |
| `auth_methods` | List of allowed authentication methods (`cleartext`, `md5`, `scram-sha-256`). Empty = all.  | No       |
| `roles`        | List of roles for authorization (e.g., `admin`, `readonly`, `readwrite`). Used with Casbin. | No       |
| `databases`    | List of databases the user is allowed to connect to. Empty = all databases.                 | No       |
| `enabled`      | Whether the user is enabled. Disabled users cannot authenticate.                            | No       |

### Authorization with Casbin

The plugin optionally supports query-level authorization using [Casbin](https://casbin.org/) RBAC. When enabled, the plugin parses incoming SQL queries to extract tables and maps SQL operations to actions:

- `SELECT` is mapped to `read`
- `INSERT`, `UPDATE`, `DELETE` are mapped to `write`
- `CREATE`, `DROP`, `ALTER`, `TRUNCATE`, `GRANT`, `REVOKE` are mapped to `admin`

The policy is checked as `(user/role, database, table, action)`. To enable authorization, set the `AUTHORIZATION_ENABLED`, `CASBIN_MODEL_PATH` and `CASBIN_POLICY_PATH` environment variables.

### Environment variables

| Name                         | Description                                                                                   | Default                                                            |
| ---------------------------- | --------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| `MAGIC_COOKIE_KEY`           | The key for the magic cookie.                                                                 | `GATEWAYD_PLUGIN`                                                  |
| `MAGIC_COOKIE_VALUE`         | The value for the magic cookie.                                                               | `5712b87aa5d7e9f9e9ab643e6603181c5b796015cb1c09d6f5ada882bf2a1872` |
| `AUTH_TYPE`                  | The default authentication method (`cleartext`, `md5`, or `scram-sha-256`).                   | `md5`                                                              |
| `CREDENTIALS_FILE`           | The path to the YAML credentials file.                                                        | `credentials.yaml`                                                 |
| `SERVER_VERSION`             | The PostgreSQL server version to advertise to clients.                                        | `17.4`                                                             |
| `METRICS_ENABLED`            | Whether to enable metrics.                                                                    | `True`                                                             |
| `METRICS_UNIX_DOMAIN_SOCKET` | The path to the Unix domain socket for exposing metrics. This must be accessible to GatewayD. | `/tmp/gatewayd-plugin-auth.sock`                                   |
| `METRICS_PATH`               | The path for exposing metrics.                                                                | `/metrics`                                                         |
| `AUTHORIZATION_ENABLED`      | Whether to enable Casbin query authorization.                                                 | `false`                                                            |
| `CASBIN_MODEL_PATH`          | The path to the Casbin model file.                                                            | (empty)                                                            |
| `CASBIN_POLICY_PATH`         | The path to the Casbin policy file.                                                           | (empty)                                                            |
| `SENTRY_DSN`                 | Sentry DSN. Set to empty string to disable Sentry.                                            | (empty)                                                            |

### Command-line arguments

| Name          | Description    | Default |
| ------------- | -------------- | ------- |
| `--log-level` | The log level. | `info`  |

## Build for testing

To build the plugin for development and testing, run the following command in the project's root directory after cloning the repository.

```bash
git clone git@github.com:gatewayd-io/gatewayd-plugin-auth.git
cd gatewayd-plugin-auth
make build-dev
```

Running the above commands clones the repository, changes the current directory and runs the `go mod tidy` and `go build` commands to compile and generate the plugin binary.
