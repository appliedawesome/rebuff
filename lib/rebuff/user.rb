module Rebuff
  class User
    include DataMapper::Resource
  
    property :id, Serial
    
    has n, :sites
  end
end