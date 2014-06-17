# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'emlauncher/register/version'

Gem::Specification.new do |spec|
  spec.name          = "emlauncher-register"
  spec.version       = Emlauncher::Register::VERSION
  spec.authors       = ["Kuchitama"]
  spec.email         = ["kiyo.kunihira@gmail.com"]
  spec.description   = %q{register user with email to EMLauncher}
  spec.summary       = %q{register user with email to EMLauncher}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_dependency "sinatra",      "~> 1.4.0"
  spec.add_dependency "erubis",       "~> 2.7.0"
  spec.add_dependency "eventmachine", "~> 1.0.3"
  spec.add_dependency "mysql2-cs-bind", "~> 0.0.6"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "redcarpet"
end
