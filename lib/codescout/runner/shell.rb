module Codescout::Runner
  class Shell
    def execute(command)
      `#{command}`
      $?.success?
    end
  end
end