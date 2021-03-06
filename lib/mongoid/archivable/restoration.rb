module Mongoid
  module Archivable
    module Restoration
      # Restores the archived document to its former glory.
      def restore
        if original_document.save
          original_document
        end
      end

      def restore!
        original_document.save!
        original_document
      end

      def original_document
        @original_document ||= begin
          excluded_attributes = %w(_id original_id original_type archived_at)
          attrs = attributes.except(*excluded_attributes)
          attrs = Mongoid::Archivable::ProcessLocalizedFields.call(original_class, attrs)

          original_class.new(attrs) do |doc|
            doc.id = original_id
          end
        end
      end

      # first, try to retrieve the original_class from the stored :original_type
      # since previous versions of this gem did not use this field, fall back
      # to previous method -- removing the '::Archive' from archive class name
      def original_class_name
        if respond_to?(:original_type) && original_type.present? # gem version >= 1.3.0, stored as a field.
          original_type
        else
          self.class.to_s.gsub(/::Archive\z/, '') # gem version < 1.3.0, turns "User::Archive" into "User".
        end
      end

      def original_class
        original_class_name.constantize
      end
    end
  end
end
