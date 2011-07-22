require "mongoid"
require 'mongoid/acts_as_list'

class Module
  def self.act_as_list
    seld.send :include Mongoid::ActsAsList
  end
end
