if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'rspec/autorun'
require 'mongoid'
require 'mongoid_embedded_helper'
# require 'mongoid_adjust'
require 'acts_as_list_mongoid'


$:.unshift "#{File.dirname(__FILE__)}/../model/"
ENV["MONGOID_ENV"]="test"
Mongoid.load! "#{File.dirname(__FILE__)}/../mongoid.yml"


