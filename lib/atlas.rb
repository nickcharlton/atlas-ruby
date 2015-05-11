require 'excon'
require 'json'

require 'atlas/version'
require 'atlas/configuration'
require 'atlas/client'
require 'atlas/user'

# Toolkit for working with Hashicorp's Atlas.
module Atlas
  attr_accessor :client

  def self.client
    @client ||= Client.new(access_token: configuration.access_token)
  end
end
