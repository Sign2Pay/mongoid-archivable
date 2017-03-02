module Mongoid
  module Archivable
    class Config
      attr_accessor :database
      attr_accessor :client

      def get_database
        database || Mongoid::Config.clients[get_client][:database]
      end

      def get_client
        client || :default
      end
    end
  end
end