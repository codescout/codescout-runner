# codescout-runner

Application to generate code analysis reports and submit to Code Scout.

## Overview

This project is one of the components used by Code Scout to initialize and execute code
analysis reports. It does not generate reports by itself but provides an environment that's
ready for further code examination by [codescout-analyzer](https://github.com/codescout/codescout-analyzer). Runner application is designed to be executed inside a Docker container, which 
provides an isolated environment, but could also be used natively. Used by [codescout-worker](https://github.com/codescout/codescout-worker).

Workflow:

- Fetches code push details from main application. Push includes git repository URL, commit details and necessary ssh keys (generated per project) needed to clone a private repository.
- Clones repository and checks out a specific git commit pushed by user
- If repository is private, installs ssh keys (id_rsa and id_rsa.pub)
- Executes codescout analyzer that produced a JSON report using Flog, Flay and other tools
- Submits a generated report back to main application

## Installation

Install from rubygems:

```
gem install codescout-runner
```

Or clone repository and build locally:

```
rake install
```

## Usage

To trigger a report build for known push, execute the following command:

```
CODESCOUT_URL=http://myhost CODESCOUT_PUSH=push_token codescout-runner
```

Where:

- `CODESCOUT_URL` - Code scout application URL (self hosted)
- `CODESCOUT_PUSH` - Push token

Also possible to execute from ruby code:

```ruby
require "codescout/runner"
Codescout::Runner.perform("url", "push")
```

## Testing

This project uses RSpec as a primary testing framework. Execute tests with following command:

```
bundle exec rake test
```

## License

The MIT License (MIT)

Copyright (c) 2014 Doejo LLC, <dan@doejo.com>