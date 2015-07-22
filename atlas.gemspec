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
  spec.homepage      = 'https://github.com/nickcharlton/atlas'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.require_paths = ['lib']

  spec.add_dependency 'excon', '~> 0.45'
  spec.add_dependency 'json', '~> 1.8'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'pry'
end
