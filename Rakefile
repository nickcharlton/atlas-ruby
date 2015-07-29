#!/usr/bin/env rake

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'bundler/gem_tasks'

##
# Configure the test suite.
##
require 'rspec/core'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new

##
# RuboCop
##
require 'rubocop/rake_task'

RuboCop::RakeTask.new do |task|
  task.requires << 'rubocop-rspec'
end

##
# By default, just run the tests.
##
task default: :spec
