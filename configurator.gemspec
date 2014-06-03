# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'configurator/version'

Gem::Specification.new do |spec|
  spec.name          = %q{configurator}
  spec.version       = Configurator::VERSION
  spec.license       = "MIT"

  spec.authors       = ["Will Bryant"]
  spec.description   = %q{Basic configuration loading}
  spec.email         = ["william@tout.com"]
  spec.summary       = %q{Basic configuration loading}
  spec.homepage      = %q{http://github.com/will3216/configurator}
  spec.files = Dir.glob("lib/**/*") + [
     "LICENSE.txt",
     "README.md",
     "Rakefile",
     "Gemfile",
     "configurator.gemspec",
  ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    =  Dir.glob("spec/**/*")
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency(%q<rails>, [">= 3.2"])
end
