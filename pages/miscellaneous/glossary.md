# Glossary

**Object**
Each configurable part of GatewayD is called an *object*, for example `logger`.

**Configuration file**
GatewayD has two YAML-based configuration files that are shipped with each release file and contains all the default values.

- `gatewayd.yaml`: the global configuration file of GatewayD.
- `gatewayd_plugins.yaml`: the plugins configuration file.

**Configuration object**
Each configuration file contains multiple configuration objects that correspond to GatewayD objects. For example, the global configuration file contains seven configuration objects: `loggers`, `metrics`, `clients`, `pools`, `proxies`, `server` and `API`.

**Configuration group**
To enable multi-tenancy, GatewayD supports configuring multiple instances of each (configuration) object using configuration groups. All the default configuration objects have a single configuration group called `default`, except the `API`.

**Configuration parameter**
A configuration object has one or many configuration parameters to set up the corresponding object. For example, the `output` parameter on the `logger` object is used to set the outputs by the `default` (configuration group) logger.
