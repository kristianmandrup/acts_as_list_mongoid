require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name        = "acts_as_list_mongoid"
    gem.summary     = %Q{acts_as_list for Mongoid}
    gem.description = %Q{Make your Mongoid model acts as a list. This acts_as extension provides the capabilities for sorting and reordering a number of objects in a list.
      The instances that take part in the list should have a +position+ field of type Integer.}
    gem.email       = "kmandrup@gmail.com"
    gem.homepage    = "http://github.com/rails/acts_as_list"
    gem.authors     = ["Kristian Mandrup"]
    gem.add_dependency "mongoid", ">= 2.0.0.beta.14"
    gem.add_dependency "mongoid_embedded_helper", ">= 0.2.5"
    # gem.add_development_dependency "yard"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

