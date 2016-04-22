# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tonsser_hash_utils/version"

Gem::Specification.new do |spec|
  spec.name          = "tonsser_hash_utils"
  spec.version       = TonsserHashUtils::VERSION
  spec.authors       = ["David Pedersen"]
  spec.email         = ["david@tonsser.com"]
  spec.summary       = "A collection of classes for dealing with hashes"
  spec.description   = ""
  spec.homepage      = "http://github.com/tonsser/tonsser_hash_utils"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)/)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_development_dependency "rspec", ">= 3.2.0"

  spec.add_runtime_dependency "activesupport", ">= 4.0"
end
