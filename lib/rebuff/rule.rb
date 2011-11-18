module Rebuff
  class Rule
    include DataMapper::Resource
    
    property :id, Serial, :index => true
    property :regexp, Regexp
  end
end