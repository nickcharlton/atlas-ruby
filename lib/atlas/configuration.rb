module Atlas
  # Configuration handling for Atlas.
  class Configuration
    # Access token for Atlas
    attr_accessor :access_token

    # Create a new Configuration instance
    #
    # This also allows providing a hash of configuration values, which calls
    # the accessor methods to full in the values.
    def initialize(opts = {})
      opts.each do |k, v|
        send("#{k}=".to_sym, v)
      end
    end

    # Hash representation of the configuration object.
    def to_h
      { access_token: @access_token }
    end

    # String representation of the configuration.
    def to_s
      objects = to_h.collect { |k, v| "#{k}=#{v}" }.join(' ')
      "#<#{self.class.name}:#{object_id} #{objects}"
    end
  end

  class << self
    attr_accessor :configuration
  end

  # Support for a configuration block.
  def self.configure
    yield configuration if block_given?
  end

  # The default configuration object.
  def self.configuration
    @configuration ||= Configuration.new
  end
end
