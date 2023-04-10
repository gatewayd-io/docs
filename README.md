# Documentation

The initial docs structure is detailed in [this comment](https://github.com/gatewayd-io/docs/issues/1#issuecomment-1442331491) and is as follows. This will be updated over time as the docs is written and shaped.

- Getting started
  - [x] [Welcome](pages/01-getting-started/01-welcome.md)
  - [x] [Installation](pages/01-getting-started/02-installation.md)
  - [x] [Running GatewayD](pages/01-getting-started/03-running-gatewayd.md)
  - [x] [Observability](pages/01-getting-started/04-observability.md)
  - [ ] [Resources](pages/01-getting-started/05-resources.md)
- Using GatewayD
  - [x] [Configuration](pages/02-using-gatewayd/01-configuration/index.md)
    - [x] [Global configuration](pages/02-using-gatewayd/01-configuration/index.md#global-configuration)
      - [x] [Loggers](pages/02-using-gatewayd/01-configuration/01-global-configuration/01-loggers.md)
      - [x] [Metrics](pages/02-using-gatewayd/01-configuration/01-global-configuration/02-metrics.md)
      - [x] [Clients](pages/02-using-gatewayd/01-configuration/01-global-configuration/03-clients.md)
      - [x] [Pools](pages/02-using-gatewayd/01-configuration/01-global-configuration/04-pools.md)
      - [x] [Proxies](pages/02-using-gatewayd/01-configuration/01-global-configuration/05-proxies.md)
      - [x] [Servers](pages/02-using-gatewayd/01-configuration/01-global-configuration/06-servers.md)
      - [x] [API](pages/02-using-gatewayd/01-configuration/01-global-configuration/07-api.md)
    - [x] [Plugins configuration](pages/02-using-gatewayd/01-configuration/index.md#plugins-configuration)
      - [x] [General configuration](pages/02-using-gatewayd/01-configuration/02-plugins/01-general-configuration.md)
      - [x] [Plugins configuration](pages/02-using-gatewayd/01-configuration/02-plugins/02-plugins-configuration.md)
    - [x] [Environment variables](pages/02-using-gatewayd/01-configuration/index.md#environment-variables)
    - [x] [Runtime configuration](pages/02-using-gatewayd/01-configuration/index.md#runtime-configuration)
  - [x] [CLI](pages/02-using-gatewayd/02-CLI.md)
  - [ ] Servers
  - [ ] Clients
  - [ ] Pools
  - [ ] Proxies
    - L4 transparent proxy
    - Health check
  - [ ] Observability
    - Loggers
    - Metrics
    - Traces
  - [ ] API
    - gRPC
    - HTTP
  - [ ] Connection lifecycle
  - [ ] Protocols
- Using plugins
  - [ ] Plugins
    - Policies
      - Verification
      - Compatibility
      - Acceptance
    - Reload on crash
    - Health check
    - Metrics merger
    - Command-line arguments
    - Environment variables
    - Checksum verification
  - [ ] Hooks
    - Types (traffic and notification)
    - Timeout
  - [ ] Plugin registry
  - [ ] Hook registry
  - [ ] Plugin types
    - Built-in plugins
    - Community plugins
    - Enterprise plugins
  - [ ] Proposals
- Developing plugins
  - [ ] Plugin lifecycle
  - [ ] SDK reference
  - [ ] gRPC API reference
  - [ ] Template projects (Go and Python)
- GatewayD versus
  - [ ] MaxScale
  - [ ] ProxySQL
  - [ ] Acra
  - [ ] Stargate
  - [ ] Heimdall Data
  - [ ] Bytebase
  - [ ] Airbyte
  - [ ] Arana
  - [ ] Bouncers (PgBouncer, PgPool-II and pgcat)
- Community
  - [ ] Learning
  - [ ] Contributing
    - GatewayD public roadmap
    - Plugins public roadmap
    - Public proposals
  - [ ] Forum
  - [ ] Chat
  - [ ] Social accounts
  - [ ] Code of conduct
  - [ ] Test server
- Misc
  - [x] [Telemetry and usage report](pages/07-miscellaneous/telemetry-and-usage-report.md)
  - [ ] Error reporting
  - [ ] Release notes
  - [ ] [Glossary](pages/07-miscellaneous/glossary.md)
