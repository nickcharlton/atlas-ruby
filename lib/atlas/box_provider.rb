module Atlas
  # Representation and handling of Box Provider objects.
  class BoxProvider < Resource
    # Properties of the provider.
    attr_accessor :name, :url

    def self.load(username, name, version, provider)
      response = Atlas.client.get("/box/#{username}/#{name}/version/" \
                                  "#{version}/provider/#{provider}")

      body = JSON.parse(response.body)
      new({ origin: { username: username,
                      box_name: name,
                      box_version: version } }.merge(body))
    end

    def initialize(hash = {})
      hash[:url] = hash[:download_url]

      super(hash)
    end

    def origin
      { username: @username, box_name: @box_name, box_version: @box_version }
    end

    def origin=(hash)
      @username = hash[:username]
      @box_name = hash[:box_name]
      @box_version = hash[:box_version]
    end

    def save # rubocop:disable Metrics/AbcSize
      body = { provider: to_hash }

      # update or create the box
      begin
        response = Atlas.client.put("/box/#{@username}/#{@box_name}/version/" \
                                    "#{@box_version}/provider/#{name}",
                                    body: body)
      rescue Excon::Errors::NotFound
        response = Atlas.client.post("/box/#{@username}/#{@box_name}/version/" \
                                     "#{@box_version}/providers", body: body)
      end

      update_with_response(response.body)
    end
  end
end
