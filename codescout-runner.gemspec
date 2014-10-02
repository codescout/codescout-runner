require File.expand_path("../lib/codescout/runner/version", __FILE__)

Gem::Specification.new do |s|
  s.name        = "codescout-runner"
  s.version     = Codescout::Runner::VERSION
  s.summary     = "No description for now"
  s.description = "No description for now, maybe later"
  s.homepage    = "https://github.com"
  s.authors     = ["Dan Sosedoff"]
  s.email       = ["dan.sosedoff@gmail.com"]
  s.license     = "MIT"

  s.add_dependency "json",               "~> 1.8"
  s.add_dependency "hashie",             "~> 3.3"
  s.add_dependency "faraday",            "~> 0.9"
  s.add_dependency "codescout-analyzer", "0.0.3"

  s.add_development_dependency "rake",      "~> 10"
  s.add_development_dependency "rspec",     "~> 3.0"
  s.add_development_dependency "simplecov", "~> 0.9"
  s.add_development_dependency "webmock",   "~> 1.18"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{|f| File.basename(f)}
  s.require_paths = ["lib"]
end