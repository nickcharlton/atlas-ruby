# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'atlas/version'

Gem::Specification.new do |spec|
  spec.name          = 'atlas'
  spec.version       = Atlas::VERSION
  spec.authors       = ['Nick Charlton']
  spec.email         = ['nick@nickcharlton.net']

  spec.summary       = 'A client for Hashicorp\'s Atlas.'
  spec.description   = 'A client for Hashicorp\'s Atlas.'
  spec.homepage      = 'https://github.com/nickcharlton/atlas-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'excon', '~> 0.45'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency "pry"
end
