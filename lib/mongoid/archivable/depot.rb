module Mongoid
  module Archivable
    module Depot
      extend ActiveSupport::Concern
      included do
        include ClassMethods
      end

      module ClassMethods
        def has_archive_storage?
          !parent_class.archive_storage.nil?
        end

        def has_archive_client?
          has_archive_storage? && !parent_class.archive_storage[:client].nil?
        end

        def has_archive_database?
          has_archive_storage? && !parent_class.archive_storage[:client].nil?
        end

        def archive_database_name
          if has_archive_database?
            parent_class.archive_storage[:database]
          else
            Mongoid::Archivable.config.get_database
          end
        end

        def archive_client_name
          if has_archive_client?
            parent_class.archive_storage[:client]
          else
            Mongoid::Archivable.config.get_client
          end
        end

        private

        def parent_class
          if ActiveSupport::VERSION::MAJOR >= 6
            model_class.module_parent
          else
            model_class.parent
          end
        end
      end
    end
  end
end
