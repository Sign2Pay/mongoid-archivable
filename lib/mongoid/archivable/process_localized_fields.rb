module Mongoid
  module Archivable
    # loops through all fields on document, as well as on its embedded relations
    # and makes sure all attributes that belong to localized fields are assigned
    # via their *_translations writer
    class ProcessLocalizedFields < Struct.new(:cls, :attrs)
      def self.call(*args)
        new(*args).call
      end

      def initialize(cls, attrs = {})
        super(cls, attrs)
      end

      def call
        attrs = convert_fields

        embedded_relations.each do |relation|
          relation_name = relation.name.to_s
          relation_class = relation.class_name.constantize

          # convert embeds_many
          if attrs[relation_name].is_a?(Array)
            attrs[relation_name] = attrs[relation_name].map do |att|
              ProcessLocalizedFields.call(relation_class, att)
            end
          # convert embeds_one
          elsif att = attrs[relation_name]
            attrs[relation_name] = ProcessLocalizedFields.call(relation_class, att)
          end
        end

        attrs
      end

      private

      def localized_fields
        cls.fields.values.select(&:localized?)
      end

      def localized_field_names
        localized_fields.map(&:name)
      end

      def convert_fields
        attrs.map do |name, value|
          if localized_field_names.include?(name.to_s)
            name = "#{name}_translations"
          end
          [name, value]
        end.to_h
      end

      def embedded_relations
        cls.relations.values.select(&:embedded?)
      end
    end
  end
end
