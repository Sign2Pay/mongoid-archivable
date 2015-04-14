$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mongoid'
require 'mongoid-archivable'

ENV['MONGOID_ENV'] = 'test'
Mongoid.load!('./spec/config/mongoid.yml')
Mongoid.purge!

class User
  include Mongoid::Document
  include Mongoid::Archivable
end
