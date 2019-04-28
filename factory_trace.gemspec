lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factory_trace/version'

Gem::Specification.new do |spec|
  spec.name          = 'factory_trace'
  spec.version       = FactoryTrace::VERSION
  spec.authors       = ['djezzzl']
  spec.email         = ['lawliet.djez@gmail.com']

  spec.summary       = 'Provide an easy way to maintain factories and traits from FactoryBot'
  spec.homepage      = 'https://github.com/djezzzl/factory_trace'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.require_paths = ['lib']

  spec.add_dependency 'factory_bot', '>= 4.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
