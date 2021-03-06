# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'excalibur/version'

Gem::Specification.new do |spec|
  spec.name          = 'excalibur'
  spec.version       = Excalibur::VERSION
  spec.authors       = ['Joost Elfering']
  spec.email         = ['yopefonic@gmail.com']
  spec.summary       = %q{helper gem to set page title and meta tags in a
                        rails app}
  spec.description   = %q{Excalibur is a SEO related gem for Ruby on Rails
                        that helps you to set the title and meta tags for your
                        site overall and per page in a nicely structured and
                        with separated concerns.}
  spec.homepage      = 'https://github.com/yopefonic/excalibur'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_dependency 'rails', '>= 3.0.0'
  spec.add_dependency 'draper', '~> 1.3', '>= 1.3.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.3'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'generator_spec', '~> 0.9', '>= 0.9.2'
  spec.add_development_dependency 'simplecov', '~> 0.8', '>= 0.8.0'
  spec.add_development_dependency 'pry', '~> 0.10', '>= 0.10.1'
end
