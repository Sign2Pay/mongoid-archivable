$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'mongoid'
require 'mongoid-archivable'

ENV['MONGOID_ENV'] = 'test'
Mongoid.load!('./spec/config/mongoid.yml')

RSpec.configure do |config|
  config.before(:each) do
    Mongoid.purge!
  end
end

class User
  include Mongoid::Document
  include Mongoid::Archivable
end

class UserSubclass < User
end

module Deeply
  module Nested
    class User
      include Mongoid::Document
      include Mongoid::Archivable
    end
  end
end
