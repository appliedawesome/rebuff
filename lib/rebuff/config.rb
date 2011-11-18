module Rebuff
  module Config
    class << self
      def config_path(config_name)
        File.expand_path(File.dirname(__FILE__) + "/../../config/#{config_name}.yml")
      end
      
      def database
        @database ||= YAML.load_file(config_path("database"))
      end
      
      alias_method :db, :database
    end
  end
end
