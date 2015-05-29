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

    def save # rubocop:disable Metrics/MethodLength
      body = { version: to_hash }

      # providers are saved seperately
      body[:version].delete(:providers)

      begin
        response = Atlas.client.put("/box/#{@username}/#{@box_name}/version/" \
                                    "#{version}", body: body)
      rescue Excon::Errors::NotFound
        response = Atlas.client.post("/box/#{@username}/#{@box_name}/versions",
                                     body: body)
      end

      # trigger the same on the providers
      providers.each(&:save) if providers

      update_with_response(response.body, [:providers])
    end
  end
end
