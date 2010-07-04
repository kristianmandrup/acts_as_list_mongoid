require 'item'

class List
  include Mongoid::Document
  include Mongoid::Timestamps 

  field :name, :type => String
  
  embeds_many :items   
end