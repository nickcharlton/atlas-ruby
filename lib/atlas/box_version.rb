module Atlas
  # Representation and handling of Box Version objects.
  class BoxVersion < Resource
    # Properties of the version.
    attr_accessor :version, :description, :status, :providers

    def self.load(username, name, version)
      response = Atlas.client.get("/box/#{username}/#{name}/version/#{version}")

      body = JSON.parse(response.body)
      new({ origin: { username: username, box_name: name } }.merge(body))
    end

    def initialize(hash = {})
      hash['description'] = hash['description_markdown']

      super(hash)
    end

    def origin
      { username: @username, box_name: @box_name }
    end

    def origin=(hash)
      @username = hash[:username]
      @box_name = hash[:box_name]
    end

    def providers=(hash)
      @providers = hash.collect do |v|
        BoxProvider.new({ origin: origin.merge(box_version: version) }.merge(v))
      end
    end
  end
end
