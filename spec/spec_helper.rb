$:.unshift File.expand_path("../..", __FILE__)

require "simplecov"

SimpleCov.start do
  add_filter "spec/"
end

require "webmock/rspec"
require "lib/codescout/runner"

def fixture_path(filename = nil)
  path = File.expand_path("../fixtures", __FILE__)
  filename.nil? ? path : File.join(path, filename)
end

def fixture(file)
  File.read(File.join(fixture_path, file))
end

def stub_shell(shell, command)
  allow(shell).to receive(:execute).with(command) { yield }
end