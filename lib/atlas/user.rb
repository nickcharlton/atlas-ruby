module Atlas
  # Representation and handling of User objects.
  class User < Resource
    attr_accessor :username, :avatar_url, :profile

    def self.find(tag)
      url_builder = UrlBuilder.new(tag)
      response = Atlas.client.get(url_builder.user_url)

      new(tag, response)
    end

    def initialize(tag, hash = {})
      hash['profile'] = hash['profile_markdown']

      super(tag, hash)
    end

    def boxes
      @boxes ||= []
    end

    def boxes=(hash)
      @boxes = hash.collect { |v| Box.new("#{username}/#{v['name']}", v) }
    end
  end
end
