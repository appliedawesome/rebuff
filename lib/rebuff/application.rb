require 'sinatra/base'
require 'uri'

module Rebuff
  class Application < Sinatra::Base
    configure do
      db = URI.parse(ENV['DATABASE_URL'] || 'redis://localhost:6379/0')
      set :app_file, __FILE__
      set :root, File.expand_path(File.join(File.dirname(__FILE__), "../../../"))
      enable :logging
      disable :run
      disable :show_exceptions
      disable :raise_errors, false
      set :server, %w[ thin mongrel webrick ]

      DataMapper.setup(:default, {
        :adapter => "redis",
        :host => db.host,
        :port => db.port,
        :database => db.path[1..-1]
      })
      
      DataMapper.finalize
      
      $redis = Redis.new({
        :adapter => "redis",
        :host => db.host,
        :port => db.port,
        :database => db.path[1..-1]
      })
    end
    
    configure :production do

    end
    
    configure :development do
      enable :raise_errors
      enable :show_exceptions
      enable :logging
      set :logger_level, :info
      set :logger_log_file, STDOUT
    end
    
    configure :test do
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