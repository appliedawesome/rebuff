require 'sinatra/base'

module Rebuff
  class Application < Sinatra::Base
    def self.setup_db(env)
      $redis = Redis.new(
        :host => Rebuff::Config.database[env]['host'],
        :port => Rebuff::Config.database[env]['port'],
        :db => Rebuff::Config.database[env]['db']
      )

      DataMapper.setup(:default, { 
        :adapter => "redis",
        :host => Rebuff::Config.database[env]['host'],
        :port => Rebuff::Config.database[env]['port'],
        :db => Rebuff::Config.database[env]['db']
      })
    end
    
    configure do
      set :app_file, __FILE__
      set :root, File.expand_path(File.join(File.dirname(__FILE__), "../../../"))
      enable :logging
      disable :run
      disable :show_exceptions
      disable :raise_errors, false
      set :server, %w[ thin mongrel webrick ]
    end
    
    configure :production do
      setup_db('production')
    end
    
    configure :development do
      setup_db('test')
      enable :raise_errors
      enable :show_exceptions
      enable :logging
      set :logger_level, :info
      set :logger_log_file, STDOUT
    end
    
    configure :test do
      setup_db('test')
      enable :raise_errors
      enable :show_exceptions
      enable :logging
      set :logger_level, :info
      set :logger_log_file, STDOUT
    end
    
    error DataMapper::ObjectNotFoundError do
      status 404
      [ "Not found" ].to_json
    end
    
  end
end