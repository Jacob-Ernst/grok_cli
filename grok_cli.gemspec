# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grok_cli/version'

Gem::Specification.new do |spec|
  spec.name          = "grok_cli"
  spec.version       = GrokCLI::VERSION
  spec.authors       = ["Josh Freeman"]
  spec.email         = ["jdfreeman11@gmail.com"]
  spec.license       = 'MIT'

  spec.summary       = "Common CLI tools designed by Grok Interactive, LLC"
  spec.homepage      = "https://github.com/GrokInteractive/grok_cli"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["grok"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_runtime_dependency "gli", '~> 2.13', '>= 2.13.4'
end
