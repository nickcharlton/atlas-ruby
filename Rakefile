require 'bundler/gem_tasks'

##
# Configure the test suite.
##
require 'rake/testtask'

Rake::TestTask.new :spec do |t|
  t.test_files = Dir['spec/*_spec.rb']
end

##
# By default, just run the tests.
##
task default: :spec
