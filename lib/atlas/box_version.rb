module Atlas
  # Representation and handling of Box Version objects.
  class BoxVersion < Resource
    attr_accessor :version, :description, :status, :providers

    def self.load(username, name, version)
      response = Atlas.client.get("/box/#{username}/#{name}/version/#{version}")

      new(JSON.parse(response.body))
    end

    def initialize(hash = {})
      hash['description'] = hash['description_markdown']

      super(hash)
    end

    def providers=(hash)
      @providers = hash.collect { |v| BoxProvider.new(v) }
    end
  end
end
