# frozen_string_literal: true

require_relative 'lib/oxml/version'

Gem::Specification.new do |spec|
  spec.name = 'oxml'
  spec.version = OXML::VERSION
  spec.author = 'xkwd'
  spec.summary = 'Fast Ruby XML to Hash parser and Hash to XML builder'
  spec.description = 'Fast Ruby XML to Hash parser and Hash to XML builder, built on top of the Ox gem (a native C extension)'
  spec.homepage = 'https://github.com/xkwd/oxml'
  spec.license = 'MIT'
  spec.files = Dir['lib/**/*']
  spec.required_ruby_version = '>= 2.6'
  spec.add_dependency 'ox', '~> 2.14'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
