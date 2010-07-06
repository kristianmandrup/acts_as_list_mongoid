class Item
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActsAsList::Mongoid 
  
  field :pos, :type => Integer
  field :number, :type => Integer
  
  acts_as_list :column => :pos

  embedded_in :list, :inverse_of => :items
end    

class List
  include Mongoid::Document
  field :name, :type => String
  embeds_many :items
end
