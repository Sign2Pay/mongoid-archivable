module Mongoid
  module Archivable
    module Gluten
      extend ActiveSupport::Concern
      included do
        include ClassMethods
      end
      module ClassMethods
        def archive_in args
          @@archive_storage = args
        end

        def archive_storage
          @@archive_storage
        end
      end
    end
  end
end