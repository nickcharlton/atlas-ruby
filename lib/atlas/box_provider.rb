module Atlas
  # Representation and handling of Box Provider objects.
  class BoxProvider < Resource
    # Properties of the provider.
    attr_accessor :name, :url

    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_provider_url)

      new(tag, JSON.parse(response.body))
    end

    def initialize(tag, hash = {})
      hash[:url] = hash[:download_url]

      super(tag, hash)
    end

    def save
      body = { provider: to_hash }

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
