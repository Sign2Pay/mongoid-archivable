source 'https://rubygems.org'

# Specify your gem's dependencies in mongoid-archivable.gemspec
gemspec

case version = ENV['MONGOID_VERSION'] || '~> 9.0'
when /9/ then gem 'mongoid', '~> 9.0'
when /8/ then gem 'mongoid', '~> 8.0'
when /7/ then gem 'mongoid', '~> 7.0'
when /6/ then gem 'mongoid', '~> 6.0'
when /5/ then gem 'mongoid', '~> 5.1'
else gem 'mongoid', version
end
