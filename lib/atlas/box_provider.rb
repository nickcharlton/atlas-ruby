module Atlas
  # Representation and handling of Box Provider objects.
  class BoxProvider
    attr_accessor :name, :hosted, :hosted_token, :original_url, :download_url,
                  :created_at, :updated_at

    def self.load(username, name, version, provider)
      response = Atlas.client.get("/box/#{username}/#{name}/version/" \
                                  "#{version}/provider/#{provider}")

      from_json(JSON.parse(response.body))
    end

    def self.from_json(json)
      provider = new
      provider.name = json['name']
      provider.hosted = json['hosted']
      provider.hosted_token = json['hosted_token']
      provider.original_url = json['original_url']
      provider.download_url = json['download_url']
      provider.created_at = json['created_at']
      provider.updated_at = json['updated_at']

      provider
    end
  end
end
