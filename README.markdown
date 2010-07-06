# Mongoid Acts as list

This is a port of the classic +acts_as_list+ to Mongoid.

This *acts_as* extension provides the capabilities for sorting and reordering a number of objects in a list. 
If you do not specify custom position +column+ in the options, a key named +pos+ will be used automatically.

## Installation

<code>gem install acts_a_list_mongoid</code>

## Usage

See the /specs folder specs that demontrate the API. Usage examples are located in the /examples folder.

## Example

<pre>
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
  todo_list.items.created! # IMPORTANT!!!

  todo_list.items.first.move_to_bottom
  todo_list.items.last.move_higher
</pre>  
  

## Running the specs

<code>rspec spec</code>


