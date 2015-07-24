module Atlas
  # Representation and handling of Box Provider objects.
  #
  # @attr_accessor [String] name The name of the provider.
  # @attr_accessor [String] download_url The url to download from.
  class BoxProvider < Resource
    attr_accessor :name, :download_url

    # Find a provider by it's tag.
    #
    # @param [String] tag the tag of the provider.
    #
    # @return [Provider] a representation of the provider.
    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_provider_url)

      new(tag, JSON.parse(response.body))
    end

    # Initialize a provider from a tag and object hash.
    #
    # @param [String] tag the tag which represents the origin on the provider.
    # @param [Hash] hash the attributes for the box
    # @param hash [String] :name The name of the provider.
    # @param hash [String] :url An HTTP URL to the box file. Omit if uploading
    #   with Atlas.
    def initialize(tag, hash = {})
      hash[:url] = hash[:download_url]

      super(tag, hash)
    end

    # Save the provider.
    #
    # @return [Hash] Atlas response object.
    def save
      body = { provider: to_hash }

      begin
        response = Atlas.client.put(url_builder.box_provider_url, body: body)
      rescue Excon::Errors::NotFound
        response = Atlas.client.post("#{url_builder.box_version_url}/providers",
                                     body: body)
      end

      update_with_response(response.body)
    end
  end
end
