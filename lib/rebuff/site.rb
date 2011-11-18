module Rebuff
  class Site
    include DataMapper::Resource
  
    property :id, Serial
    
    belongs_to :user
  end
end