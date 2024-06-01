<p align="center">
  <a href="https://docs.gatewayd.io/">
    <picture>
      <img alt="gatewayd-docs" src="https://github.com/gatewayd-io/docs/blob/main/assets/gatewayd-docs.png" width="96" />
    </picture>
  </a>
  <h3 align="center">GatewayD Documentation</h3>
  <p align="center">The source code and markdown files for the GatewayD documentation</p>
</p>

<p align="center">
    <a href="https://docs.gatewayd.io/">Documentation</a>
</p>

> [!IMPORTANT]
> The pre-commit hook is used to update the `last_modified_date` field in the frontmatter for each page. It will run automatically upon committing changes if you run the following commands to enable them:
>
> ```bash
> ln .git/hooks/pre-commit .githooks/pre-commit/01-update-last-modified-date
> git config core.hooksPath .githooks
> ```

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
