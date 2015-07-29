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

    # Create a new Provider.
    #
    # @param [String] box_version_tag the box version tag to create the provider
    #   under.
    # @param [String] tag the tag which represents the origin on the provider.
    # @param [Hash] hash the attributes for the box
    # @param hash [String] :name The name of the provider.
    # @param hash [String] :url An HTTP URL to the box file. Omit if uploading
    #   with Atlas.
    def self.create(box_version_tag, attr = {})
      tag = "#{box_version_tag}/#{attr[:name]}"
      provider = new(tag, attr)
      provider.save
      provider
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
      rescue Atlas::Errors::NotFoundError
        response = Atlas.client.post("#{url_builder.box_version_url}/providers",
                                     body: body)
      end

      update_with_response(response.body)
    end

    # Upload a .box file for this provider.
    #
    # @param [File] file a File object for the file.
    def upload(file)
      # get the path for upload
      response = Atlas.client.get("#{url_builder.box_provider_url}/upload")

      # upload the file
      upload_url = JSON.parse(response.body)['upload_path']
      Excon.put(upload_url, body: file)
    end

    # Delete the provider.
    #
    # @return [Hash] Atlas response object.
    def delete
      response = Atlas.client.delete(url_builder.box_provider_url)

      JSON.parse(response.body)
    end
  end
end
