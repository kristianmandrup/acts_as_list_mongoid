$:.unshift "#{File.dirname(__FILE__)}/..spec/"
require 'spec_helper'

Config.setup_db

class TodoList  
  include MongoMapper::Document  

  key :name, String
  
  many :todo_items, :order => "position"
end

class TodoItem < Mixin
  
  include MongoMapper::Document
  include ActsAsList::MongoMapper
  
  key :todo_list_id, ObjectId
  belongs_to :todo_list

  key :name, String

  acts_as_list :scope => :todo_list

end

todo_list = TodoList.new 'My todo list'

%w{'clean', 'wash', 'repair'}.each do |name| 
  todo_item = TodoItem.new(:name => name)
  todo_list.todo_items << todo_itemend  

todo_list.todo_items.first.move_to_bottom
todo_list.todo_items.last.move_higher
