require 'list_mixin'

class Item < ListMixin
  include Mongoid::Document
  include Mongoid::Timestamps 

  field :original_id, :type => Integer  
  
  embedded_in :list, :inverse_of => :items   
end    

class BasicItem           
  include Mongoid::Document 
  
  field :original_id, :type => Integer  
  field :pos, :type => Integer  
  
  include ActsAsList::Mongoid
  acts_as_list :column => "pos", :scope => :parent
end   


class SimpleItem           
  include Mongoid::Document 
  
  field :original_id, :type => Integer  
  field :pos, :type => Integer  
  
  include ActsAsList::Mongoid
  acts_as_list :column => "pos", :scope => :parent    
  
  embedded_in :simple_list, :inverse_of => :simple_items     
end   

class SimpleList
  include Mongoid::Document
  include Mongoid::Timestamps 

  field :name, :type => String
  
  embeds_many :simple_items   
end