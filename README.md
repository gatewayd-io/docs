# Documentation

The initial docs structure is detailed in [this comment](https://github.com/gatewayd-io/docs/issues/1#issuecomment-1442331491) and is as follows. This will be updated over time as the docs is written and shaped.

<details>

<summary>TOC</summary>

- Getting started
  - [x] [Welcome](/getting-started/welcome.md)
  - [x] [Installation](/getting-started/installation.md)
  - [x] [Running GatewayD](/getting-started/running-gatewayd.md)
  - [ ] [Resources](/getting-started/resources.md)
- Using GatewayD
  - [x] [Configuration](/using-gatewayd/configuration.md)
    - [x] [Global configuration](/using-gatewayd/configuration.md#global-configuration)
      - [x] [Loggers](/using-gatewayd/global-configuration/loggers.md)
      - [x] [Metrics](/using-gatewayd/global-configuration/metrics.md)
      - [x] [Clients](/using-gatewayd/global-configuration/clients.md)
      - [x] [Pools](/using-gatewayd/global-configuration/pools.md)
      - [x] [Proxies](/using-gatewayd/global-configuration/proxies.md)
      - [x] [Servers](/using-gatewayd/global-configuration/servers.md)
      - [x] [API](/using-gatewayd/global-configuration/api.md)
    - [x] [Plugins configuration](/using-gatewayd/configuration.md#plugins-configuration)
      - [x] [General configuration](/using-gatewayd/plugins-configuration/general-configurations.md)
      - [x] [Plugins configuration](/using-gatewayd/plugins-configuration/plugins-configuration.md)
    - [x] [Environment variables](/using-gatewayd/configuration.md#environment-variables)
    - [x] [Runtime configuration](/using-gatewayd/configuration.md#runtime-configuration)
  - [x] [CLI](/using-gatewayd/CLI.md)
  - [x] [Servers](/using-gatewayd/servers.md)
  - [x] [Clients](/using-gatewayd/clients.md)
  - [x] [Pools](/using-gatewayd/pools.md)
  - [x] [Proxies](/using-gatewayd/proxies.md)
  - [x] [Observability](/using-gatewayd/observability.md)
  - [x] [API](/using-gatewayd/API.md)
  - [x] [Connection lifecycle](/using-gatewayd/connection-lifecycle.md)
  - [x] [Protocols](/using-gatewayd/protocols.md)
- Using plugins
  - [x] [Plugins](/using-plugins/plugins.md)
  - [x] [Hooks](/using-plugins/hooks.md)
  - [x] [Plugin registry](/using-plugins/plugin-registry.md)
  - [x] [Hook registry](/using-plugins/hook-registry.md)
  - [x] [Plugin types](/using-plugins/plugin-types.md)
  - [x] [Proposals](/using-plugins/proposals.md)
- Developing plugins
  - [x] [Plugin developers guide](/developing-plugins/plugin-developers-guide.md)
  - [x] [SDK](/developing-plugins/sdk-reference.md)
  - [x] [gRPC API reference](/developing-plugins/grpc-api-reference.md)
  - [x] [Template projects](/developing-plugins/template-projects.md)
- Plugins
  - [x] [gatewayd-plugin-cache](/plugins/gatewayd-plugin-cache.md)
- GatewayD versus (move to the blog?)
  - [ ] Bouncers (`PgBouncer`, `PgPool-II` and `pgcat`)
  - [ ] `MaxScale`
  - [ ] `ProxySQL`
  - [ ] `Acra`
  - [ ] `Stargate`
  - [ ] `Heimdall Data`
  - [ ] `Bytebase`
  - [ ] `Airbyte`
  - [ ] `Arana`
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
  - [x] [Telemetry and usage report](/miscellaneous/telemetry-and-usage-report.md)
  - [ ] Error reporting
  - [ ] Release notes
  - [ ] [Glossary](/miscellaneous/glossary.md)

</details>

## Running the docs locally

The docs are built using [Jekyll](https://jekyllrb.com/) and the [just-the-docs](https://just-the-docs.github.io/just-the-docs/) theme. To run the docs locally, you need to have Git and Ruby installed. Then, install Jekyll and `bundler`:

```bash
gem install jekyll bundler
```

Then, install the dependencies:

```bash
bundle install
```

Finally, run the docs:

```bash
bundle exec jekyll serve
```

If you want to clean the build directory, run:

```bash
bundle exec jekyll clean
```

## GitHub Releases Tag

The GitHub Releases Tag is a special tag that is used to retrieve the latest tag name for a repository on GitHub. It is used to display the latest version of GatewayD in the docs. To update the tags in the docs, just rebuild the docs locally and push the changes to the `main` branch. The GitHub Releases Tag will be updated automatically.

To use the tag in the docs, use the following Liquid tag:

```liquid
{% github_latest_release gatewayd-io/gatewayd v %}
```

The first parameter is the repository name in the format `owner/repo`. The second parameter is used to remove the prefix of the tag name. For example, if the tag name is `v1.0.0`, the second parameter will remove the `v` prefix and display only `1.0.0`. If omitted, the tag name will be displayed as is, including the prefix.

For private repositories, you can set the `GITHUB_TOKEN` environment variable with a [personal access token](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) to authenticate with GitHub. If the token is not provided, the tag will be displayed as `unknown`.

The tag can be used multiple times in the same page. A single request will be made to the GitHub API to retrieve the latest tag name for each repository.

## Latest modified date

The `generate_last_modified_data.sh` script is used to generate the `last_modified_date` data in the frontmatter for each page. It should be run manually before pushing the changes to the `main` branch.

```bash
bash generate_last_modified_data.sh
```
