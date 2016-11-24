# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid/archivable/version'

Gem::Specification.new do |spec|
  spec.name          = 'mongoid-archivable'
  spec.version       = Mongoid::Archivable::VERSION
  spec.authors       = ['Joost Baaij']
  spec.email         = ['joost@spacebabies.nl']

  spec.summary       = 'Move Mongoid documents to an archive instead of destroying them.'
  spec.description   = 'Move Mongoid documents to an archive instead of destroying them.'
  spec.homepage      = 'https://github.com/Sign2Pay/mongoid-archivable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'mongoid', '>= 5.0'
  spec.add_dependency 'activesupport', '>= 4.0.0'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.2.0'
end
