module Codescout::Runner
  module Shell
    def shell(command)
      # TODO: Replace backtick with proper shell execution.
      # Maybe use posix/spawn.
      `#{command}`
    end
  end
end