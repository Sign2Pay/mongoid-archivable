require "mongoid/archivable/version"

module Mongoid
  module Archivable

    extend ActiveSupport::Concern

    included do
      self.const_set("Archive", Class.new)
      self.const_get("Archive").send(:include, ::Mongoid::Document).class_eval do
        include Mongoid::Attributes::Dynamic
        field :archived_at, type: Time
        field :original_id, type: String
      end

      before_destroy :archive
    end

    private

    def archive
      self.class.const_get("Archive").create(attributes.except("_id")) do |doc|
        doc.original_id = self.id
        doc.archived_at = Time.now.utc
      end
    end

  end
end
