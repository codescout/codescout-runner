require "codescout/runner/version"
require "codescout/runner/shell"
require "codescout/runner/client"
require "codescout/runner/key"
require "codescout/runner/build"

module Codescout
  module Runner
    def self.perform(service_url, push_token)
      Codescout::Runner::Build.new(service_url, push_token).run
    end
  end
end