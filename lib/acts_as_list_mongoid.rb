require "mongoid"
require 'mongoid/acts_as_list'

class Module
  def act_as_list
    self.send :include, ActsAsList::Mongoid
  end
end
