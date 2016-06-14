# Gitlab.cr

Gitlab.cr is a [GitLab API][gitlab-api-link] wrapper writes with [Crystal][crystal-link] Language.
Inspired from [gitlab][gitlab-gem-link] gem for ruby version.

## Status

Learning Crystal language, and **WORKIONG IN PROCESS**, please DO NOT use it in production environment.

This shards code with crystal v0.17.4 (2016-05-26)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  gitlab.cr:
    github: icyleaf/gitlab.cr
```

## Usage

```crystal
require "gitlab"

endpoint = "http://domain.com/api/v3"
token = "<private_token>"

begin
  request = Gitlab::Request.new(endpoint, token)
  pp request.body
rescue ex
  pp ex.message
end
```

## Progress

> TODO: Fix it

## Contributing

1. Fork it ( https://github.com/[your-github-name]/gitlab/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [icyleaf](https://github.com/icyleaf) aka 三火 - creator, maintainer


[gitlab-api-link]: http://docs.gitlab.com/ce/api/README.html
[crystal-link]: http://crystal-lang.org/
[gitlab-gem-link]: https://github.com/NARKOZ/gitlab