---
layout: default
title: Loggers
nav_order: 1
parent: Global Configuration
grand_parent: Using GatewayD
---

# Loggers

GatewayD supports multiple loggers, and each logger supports sending logs to multiple log outputs. Here you can find all the parameters you can configure for each log output:

## Configuration parameters

| Name   | Type           | Default value | Possible values                                | Description |
| ------ | -------------- | ------------- | ---------------------------------------------- | ----------- |
| output | list of string | ["console"]   | console, stdout, stderr, syslog, rsyslog, file | Log outputs |
| level  | string         | info          | trace, debug, info, warn, error, fatal, panic  | Log level   |

### Console

| Name              | Type    | Default value | Possible values                                                    | Description                                       |
| ----------------- | ------- | ------------- | ------------------------------------------------------------------ | ------------------------------------------------- |
| noColor           | boolean | False         | True, False                                                        | Whether to disable color output in console or not |
| timeFormat        | string  | unix          | unixms, unixmicro, unixnano                                        | Time format                                       |
| consoleTimeFormat | string  | RFC3339       | Datetime format [constants](https://pkg.go.dev/time#pkg-constants) | Datetime format                                   |

### File

| Name       | Type    | Default value | Possible values   | Description                                                                                         |
| ---------- | ------- | ------------- | ----------------- | --------------------------------------------------------------------------------------------------- |
| fileName   | string  | gatewayd.log  | Valid filenames   |                                                                                                     |
| maxSize    | number  | 500           | Positive integers | Max size of each log file in megabytes before rotation                                              |
| maxBackups | number  | 5             | Positive integers | Max number of old rotated log files to retain                                                       |
| maxAge     | number  | 30            | Positive integers | Max amount of time to keep the backup files (in days) based on encoded time in the files            |
| compress   | boolean | True          | True, False       | Whether to compress rotated backup files or not                                                     |
| localTime  | boolean | False         | True, False       | Whether to use the local system time for formatting the timestamps in backup files. Default is UTC. |

### Rsyslog

| Name           | Type   | Default value | Possible values                                       | Description                                                                                                                               |
| -------------- | ------ | ------------- | ----------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| rsyslogNetwork | string | tcp           | unix, udp, tcp                                        | The network protocol to use                                                                                                               |
| rsyslogAddress | string | localhost:514 | Valid host:port                                       | The address of the rsyslog server                                                                                                         |
| syslogPriority | string | info          | debug, notice, info, warning, err, crit, alert, emerg | [Priority](https://pkg.go.dev/log/syslog#Priority) is a combination of the syslog facility and severity. Facility is set to `LOG_DAEMON`. |

## Example configuration

```yaml
loggers:
  default:
    output: ["console"] # "stdout", "stderr", "syslog", "rsyslog" and "file"
    level: "info" # panic, fatal, error, warn, info (default), debug, trace
    noColor: False
    timeFormat: "unix" # unixms, unixmicro and unixnano
    consoleTimeFormat: "RFC3339" # Go time format string
    # If output is file, the following fields are used.
    fileName: "gatewayd.log"
    maxSize: 500 # MB
    maxBackups: 5
    maxAge: 30 # days
    compress: True
    localTime: False
    # Rsyslog config
    rsyslogNetwork: "tcp"
    rsyslogAddress: "localhost:514"
    syslogPriority: "info" # emerg, alert, crit, err, warning, notice, debug
```