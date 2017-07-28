$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

# pull in the VCR setup
require File.expand_path './support/vcr_setup.rb', __dir__

# pull in the library
require 'atlas'
