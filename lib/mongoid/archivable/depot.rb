module Mongoid
  module Archivable
    module Depot
      extend ActiveSupport::Concern
      included do
        include ClassMethods
      end

      module ClassMethods
        def has_archive_storage?
          !parent.archive_storage.nil?
        end

        def has_archive_client?
          has_archive_storage? && !parent.archive_storage[:client].nil?
        end

        def has_archive_database?
          has_archive_storage? && !parent.archive_storage[:client].nil?
        end

        def archive_database_name
          if has_archive_database?
            parent.archive_storage[:database]
          else
            Mongoid::Archivable.config.get_database
          end
        end

        def archive_client_name
          if has_archive_client?
            parent.archive_storage[:client]
          else
            Mongoid::Archivable.config.get_client
          end
        end
      end
    end
  end
end