module Atlas
  # Representation and handling of Box Provider objects.
  class BoxProvider < Resource
    attr_accessor :name, :url

    def self.load(username, name, version, provider)
      response = Atlas.client.get("/box/#{username}/#{name}/version/" \
                                  "#{version}/provider/#{provider}")

      new(JSON.parse(response.body))
    end

    def initialize(hash = {})
      hash[:url] = hash[:download_url]

      super(hash)
    end
  end
end
