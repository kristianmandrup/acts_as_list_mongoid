# see http://www.viget.com/extend/getting-started-with-mongodb-mongomapper/
require 'default_behavior'

class Mixin
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :pos, :type => Integer  
  field :parent_id, :type => BSON::ObjectID  
  
#  before_save :log_before_save  
#  before_create :add_to_list_bottom #_when_necessary

  def self.table_name 
    "mixins" 
  end

  include DefaultBehavior    
end  
