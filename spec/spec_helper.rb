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

  field :localized_field, type: String, localize: true

  embeds_one :document_embedded_in_user, class_name: 'DocumentEmbeddedInUser'
  embeds_many :documents_embedded_in_user, class_name: 'DocumentEmbeddedInUser'
end

class UserSubclass < User
end

class UserTenant < User
  archive_in database: 'archives', clients: 'secondary'
end

module Deeply
  module Nested
    class User
      include Mongoid::Document
      include Mongoid::Archivable
    end
  end
end

module Deeply
  module Nested
    class UserTenant
      include Mongoid::Document
      include Mongoid::Archivable
      archive_in database: 'archives', clients: 'secondary'
    end
  end
end

class DocumentEmbeddedInUser
  include Mongoid::Document
  field :localized_field, type: String, localize: true
end
