# Mongoid Acts as list

This is a port of the classic +acts_as_list+ to Mongoid.

This *acts_as* extension provides the capabilities for sorting and reordering a number of objects in a list. 
If you do not specify custom position +column+ in the options, a key named +pos+ will be used automatically.

## Installation

<code>gem install acts_as_list_mongoid</code>

## Usage

See the /specs folder specs that demontrate the API. Usage examples are located in the /examples folder.

## Update 26, Nov 2010

The gem doesn't seem to work with the latest versions of Mongoid (> beta14), please help fix this ;)
Usage has been simplified using a suggestion by 'KieranP'

To make a class Act as List, simply do:

<pre>
  include ActsAsList::Mongoid   
</pre>

And it will automatically set up a field and call acts_as_list with that field. By default the field name is :position.
You can change the defaut position_column name used: <code>ActsAsList::Mongoid.default_position_column = :pos</code>.
For this class variable to be effetive, it should be set before calling <code>include ActsAsList::Mongoid</code>. 

## Example

<pre>
  require 'mongoid'
  require 'mongoid_embedded_helper'

  Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')

  class Item
    include Mongoid::Document
    include Mongoid::Timestamps
    include ActsAsList::Mongoid 
    
    field :number, :type => Integer
    
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
  todo_list.items.init_list! # IMPORTANT!!!

  todo_list.items.first.move(:bottom)
  todo_list.items.last.move(:higher)
</pre>  

## Overriding defaults

By default, when including ActsAsList::Mongoid, the field is set to :pos and the acts_as_list column to :pos. 
To change this:

<pre>
  include ActsAsList::Mongoid   
  
  field :pos, :type => Integer
  acts_as_list :column => :pos
</pre>


### List initialization 

In order for the list items to be initialized properly, it is necessary to call the method <code>init_list!</code> on the
collection in order for the position of each list item to be set to an initial position.

+Example:+
<code>todo_list.items.init_list!</code>

## New move API borrowed from Data Mapper *in-list* plugin
     
<pre>
item.move(:highest)          # moves to top of list.
item.move(:lowest)           # moves to bottom of list.
item.move(:top)              # moves to top of list.
item.move(:bottom)           # moves to bottom of list.
item.move(:up)               # moves one up (:higher and :up is the same) within the scope.
item.move(:down)             # moves one up (:lower and :down is the same) within the scope.
item.move(:to => position)   # moves item to a specific position.
item.move(:above => other)   # moves item above the other item.*
item.move(:below => other)
<pre>

## Running the specs

<code>rspec spec</code>


