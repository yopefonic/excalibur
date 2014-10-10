# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'excalibur/version'

Gem::Specification.new do |spec|
  spec.name          = 'excalibur'
  spec.version       = Excalibur::VERSION
  spec.authors       = ['Joost Elfering']
  spec.email         = ['yopefonic@gmail.com']
  spec.summary       = %q{helper gem to set page title and meta tags in a rails app}
  spec.description   = %q{helper gem for rails apps to set the title and meta tags for a page. The helper can take custom input per page, objects that use decorator to determine the tags or an application wide configurable default.}
  spec.homepage      = 'https://github.com/yopefonic/excalibur'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'rails', '>= 3.0.0'
  spec.add_dependency 'draper', '>= 1.3.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'generator_spec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'pry'
end
