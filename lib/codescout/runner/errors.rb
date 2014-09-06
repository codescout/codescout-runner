module Codescout::Runner
  class Error < StandardError ; end
  class ClientError < Error ; end
  class BuildError < Error ; end
end