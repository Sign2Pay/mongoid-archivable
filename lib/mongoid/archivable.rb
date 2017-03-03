require 'active_support/concern'
require 'mongoid/archivable/process_localized_fields'
require 'mongoid/archivable/restoration'
require 'mongoid/archivable/config'
require 'mongoid/archivable/gluten'
require 'mongoid/archivable/depot'

module Mongoid
  module Archivable
    extend ActiveSupport::Concern

    class << self
      def config
        @config ||= Config.new
        @config
      end

      def configure(&proc)
        yield config
      end
    end

    included do
      mattr_accessor :archive_storage
      include Mongoid::Archivable::Gluten

      const_set('Archive', Class.new)
      const_get('Archive').class_eval do
        include Mongoid::Document
        include Mongoid::Attributes::Dynamic
        include Mongoid::Archivable::Restoration
        include Mongoid::Archivable::Depot
        store_in database: ->{ archive_database_name }, client: ->{ archive_client_name }

        field :archived_at, type: Time
        field :original_id, type: String
        field :original_type, type: String
        
      end

      before_destroy :archive
    end

    private

    def archive
      self.class.const_get('Archive').create(attributes.except('_id', '_type')) do |doc|
        doc.original_id = id
        doc.original_type = self.class.to_s
        doc.archived_at = Time.now.utc
      end
    end
  end
end
