module Atlas
  # Representation and handling of User objects.
  class User < Resource
    attr_accessor :username, :avatar_url, :profile

    def self.load(name)
      response = Atlas.client.get("/user/#{name}")

      new(JSON.parse(response.body))
    end

    def initialize(hash = {})
      hash['profile'] = hash['profile_markdown']

      super(hash)
    end

    def boxes
      @boxes ||= []
    end

    def boxes=(hash)
      @boxes = hash.collect { |v| Box.new(v) }
    end
  end
end
