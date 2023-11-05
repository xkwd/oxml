# frozen_string_literal: true

require_relative 'lib/oxml/version'

Gem::Specification.new do |spec|
  spec.name = 'oxml'
  spec.version = OXML::VERSION
  spec.author = 'xkwd'
  spec.summary = 'Fast XML to Hash parser'
  spec.description = 'Fast XML to Hash parser built on top of the Ox gem (a native C extension)'
  spec.homepage = 'https://github.com/xkwd/oxml'
  spec.license = 'MIT'
  spec.files = Dir['lib/**/*']
  spec.required_ruby_version = '>= 2.7'
  spec.add_dependency 'ox', '~> 2.14'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
