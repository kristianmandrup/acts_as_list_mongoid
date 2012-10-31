if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

require 'rspec'
require 'rspec/autorun'
require 'mongoid'
require 'mongoid_embedded_helper'
require 'acts_as_list_mongoid'
require 'mongoid_helper'

$:.unshift "#{File.dirname(__FILE__)}/../model/"
ENV["MONGOID_ENV"]="test"

MongoidHelper.init_mongoid_config!