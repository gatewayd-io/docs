require 'logger'
require 'json'
require 'octokit'
require 'faraday'
require 'faraday/http_cache'

module Jekyll
    # Usage: {% github_releases <repository> %}
    # Example: {% github_releases jekyll/jekyll %}
    # Output: v3.8.5
    # Description: Fetches the latest release tag name from GitHub
    # Source:
    class GitHubLatestRelease < Liquid::Tag
        def initialize(tag_name, input, tokens)
            super
            input_split = input.split(' ')

            @repo = input_split[0].strip
            logger = Logger.new(STDOUT)

            begin
                # Configure Faraday to use HTTP caching
                stack = Faraday::RackBuilder.new do |builder|
                    builder.use Faraday::HttpCache, serializer: Marshal, shared_cache: false
                    builder.use Octokit::Response::RaiseError
                    builder.adapter Faraday.default_adapter
                end
                Octokit.middleware = stack

                # Create a new Octokit client
                if ENV['GITHUB_TOKEN'] == nil
                    client = Octokit::Client.new
                else
                    client = Octokit::Client.new(:access_token => ENV['GITHUB_TOKEN'])
                end

                # Fetch the latest release from GitHub
                @latest_release = client.latest_release(@repo)
                # Get the latest release tag name from GitHub
                if input_split.length > 1
                    strip_prefix = input_split[1]
                else
                    strip_prefix = nil
                end

                if strip_prefix != nil
                    @tag_name = @latest_release.tag_name.gsub(strip_prefix.strip, '')
                else
                    @tag_name = @latest_release.tag_name
                end
            rescue
                logger.warn("GitHubLatestRelease: Error fetching latest release for #{@repo}")
                @tag_name = "unknown"
            end
        end

        def render(context)
            "#{@tag_name}"
        end
    end
end

Liquid::Template.register_tag('github_latest_release', Jekyll::GitHubLatestRelease)
