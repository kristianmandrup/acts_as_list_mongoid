require 'rspec'
require 'rspec/autorun'
require 'mongoid'
require 'acts_as_list_mongoid'

$:.unshift "#{File.dirname(__FILE__)}/../model/"

require 'list'

Mongoid.configure.master = Mongo::Connection.new.db('acts_as_list-test')


