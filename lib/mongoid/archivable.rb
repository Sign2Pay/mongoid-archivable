require 'active_support/concern'

module Mongoid
  module Archivable

    extend ActiveSupport::Concern

    module Restoration
      # Restores the archived document to its former glory.
      def restore
        original_document.tap(&:save)
      end

      def original_document
        self.original_class_name.constantize.new(attributes.except("_id", "original_id", "original_type", "archived_at")) do |doc|
          doc.id = self.original_id
        end
      end

      # first, try to retrieve the original_class from the stored :original_type
      # since previous versions of this gem did not use this field, fall back
      # to previous method -- removing the '::Archive' from archive class name
      def original_class_name
        if self.respond_to?(:original_type) && self.original_type.present? # gem version >= 1.3.0, stored as a field.
          self.original_type
        else
          self.class.to_s.gsub(/::Archive\z/, '') # gem version < 1.3.0, turns "User::Archive" into "User".
        end
      end
    end

    included do
      self.const_set("Archive", Class.new)
      self.const_get("Archive").class_eval do
        include Mongoid::Document
        include Mongoid::Attributes::Dynamic
        include Mongoid::Archivable::Restoration
        field :archived_at, type: Time
        field :original_id, type: String
        field :original_type, type: String
      end

      before_destroy :archive
    end

    private

    def archive
      self.class.const_get("Archive").create(attributes.except("_id", "_type")) do |doc|
        doc.original_id = self.id
        doc.original_type = self.class.to_s
        doc.archived_at = Time.now.utc
      end
    end

  end
end
