# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
    gem.name        = "acts_as_list_mongoid"
    gem.summary     = %Q{acts_as_list for Mongoid}
    gem.description = %Q{Make your Mongoid model acts as a list. This acts_as extension provides the capabilities for sorting and reordering a number of objects in a list.
      The instances that take part in the list should have a +position+ field of type Integer.}
    gem.email       = "kmandrup@gmail.com"
    gem.homepage    = "http://github.com/rails/acts_as_list"
    gem.authors     = ["Kristian Mandrup"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task :default => :spec

desc "Run RSpec with code coverage"
task :coverage do
  ENV['COVERAGE'] = "true"
  Rake::Task[:spec].execute
end


require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "acts_as_list_mongoid #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end



