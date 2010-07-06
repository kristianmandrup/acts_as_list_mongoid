require 'mongoid'
require 'mongoid_embedded_helper'
                 
Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')


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


todo_list = List.new :name => 'My todo list'

%w{'clean', 'wash', 'repair'}.each do |name| 
  todo_item = Item.new(:name => name)
  todo_list.items << todo_item
end  
todo_list.items.created!

todo_list.items.first.move_to_bottom
todo_list.items.last.move_higher
