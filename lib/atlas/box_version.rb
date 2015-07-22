module Atlas
  # Representation and handling of Box Version objects.
  class BoxVersion < Resource
    # Properties of the version.
    attr_accessor :version, :description, :status, :providers

    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_version_url)

      new(tag, JSON.parse(response.body))
    end

    def initialize(tag, hash = {})
      hash['description'] = hash['description_markdown']

      super(tag, hash)
    end

    def providers=(attr)
      @providers = attr.collect do |v|
        BoxProvider.new("#{tag}/#{v['name']}", v)
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
