# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'infrataster/plugin/firewall/version'

Gem::Specification.new do |spec|
  spec.name          = 'infrataster-plugin-firewall'
  spec.version       = Infrataster::Plugin::Firewall::VERSION
  spec.authors       = ['Hiroshi Ota']
  spec.email         = ['otahi.pub@gmail.com']
  spec.summary       = 'Firewall plugin for Infrataster.'
  spec.description   = 'Firewall plugin for Infrataster.'
  spec.homepage      = 'https://github.com/otahi/infrataster-plugin-firewall'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'infrataster', '~> 0.2.0'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '0.28.0'
  spec.add_development_dependency 'coveralls', '~> 0.7'
  spec.add_development_dependency 'byebug' if RUBY_VERSION >= '2.0'
end
