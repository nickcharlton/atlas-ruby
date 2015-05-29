module Atlas
  # Representation and handling of Box objects.
  class Box < Resource
    attr_accessor :name, :username, :short_description, :description,
                  :is_private, :current_version, :versions

    def self.load(username, name)
      response = Atlas.client.get("/box/#{username}/#{name}")

      new(JSON.parse(response.body))
    end

    def initialize(hash = {})
      hash['is_private'] = hash['private']
      hash['description'] = hash['description_markdown']

      super(hash)
    end

    def current_version=(hash)
      @current_version = BoxVersion.new(
        { origin: { username: username, box_name: name } }.merge(hash)
      ) if hash.is_a? Hash
    end

    def versions=(hash)
      @versions = hash.collect do |v|
        BoxVersion.new(
          { origin: { username: username, box_name: name } }.merge(v)
        )
      end
    end
  end
end
