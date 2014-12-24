# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'table_cloth/version'

Gem::Specification.new do |gem|
  gem.name          = "table_cloth"
  gem.version       = TableCloth::VERSION
  gem.authors       = ["Robert Ross"]
  gem.email         = ["robert@creativequeries.com"]
  gem.description   = %q{Table Cloth helps you create tables easily.}
  gem.summary       = %q{Table Cloth provides an easy and intuitive DSL for creating tables for Rails views.}
  gem.homepage      = "http://www.github.com/bobbytables/table_cloth"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec', '~> 2.99.0')
  gem.add_development_dependency('rspec-collection_matchers')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('awesome_print')
  gem.add_development_dependency('nokogiri')
  gem.add_development_dependency('pry')
  gem.add_development_dependency('factory_girl')
  gem.add_development_dependency('guard-rspec')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rb-fsevent', '~> 0.9.4')

  gem.add_dependency('actionpack', '>= 3.1', '< 5.0')
  gem.add_dependency('element_factory', '~> 0.1.3')
end
