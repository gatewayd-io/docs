---
last_modified_date: 2024-02-18 12:58:36 +0100
layout: default
title: Telemetry and Usage Report
description: Telemetry and usage report of GatewayD
nav_order: 1
parent: Miscellaneous
---

# Telemetry and Usage Report

GatewayD application collects and send some pieces of information to the following services:

## GatewayD usage report service

The application sends the following information to the GatewayD usage report service. The service is enabled by default and can be disabled with the `--usage-report=false` flag of the `run` subcommand. The service is used to collect information about the usage of the application and plugins and is not used for any other purpose. We will do our best to keep the information collected by the service anonymous (no PII) and not to share it with any third parties. Also, the service is not used to track users or their activity. The information is reported every time the application is started and includes the following:

1. Version of the application (string)
2. Runtime version of Go (string)
3. Go operating system (string)
4. Go architecture (string)
5. Service name (constant string, `gatewayd`)
6. Development mode (boolean)
7. List of plugins with their name, version and checksum (list of object (strings))

### Implementation details of usage report service

The protocol buffer and gRPC definitions of the service can be found in the [usagereport](https://github.com/gatewayd-io/gatewayd/tree/main/usagereport) directory of the GatewayD repository and the implementation can be found [here](https://github.com/gatewayd-io/gatewayd/blob/d19014aa1d552f44abede96987188ddfd8fd2bf6/cmd/run.go#L560-L602).

## Sentry error reporting service

The application sends the following information to the Sentry error reporting service. The service is enabled by default and can be disabled with the `--sentry=false` flag of all the subcommands. The service is used to report errors and crashes of the application and plugins and is not used for any other purpose.

### Implementation details of Sentry error reporting service

Please visit [this link](https://github.com/gatewayd-io/gatewayd/blob/d19014aa1d552f44abede96987188ddfd8fd2bf6/cmd/run.go#L84-L104) to see how the service is implemented in the application.
