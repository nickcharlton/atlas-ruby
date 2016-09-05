module Atlas
  # Representation and handling of Box Provider objects.
  #
  # @attr_accessor [String] name The name of the provider.
  # @attr_accessor [String] download_url The url to download from.
  class BoxProvider < Resource
    attr_accessor :name, :original_url, :download_url, :url
    date_accessor :created_at, :updated_at

    # Find a provider by it's tag.
    #
    # @param [String] tag the tag of the provider.
    #
    # @return [Provider] a representation of the provider.
    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_provider_url)

      new(tag, response)
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
      hash[:url] = hash[:download_url] unless hash.key? :url

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

      update_with_response(response)
    end

    # Upload a .box file for this provider.
    #
    # @param [File] file a File object for the file.
    def upload(file, chunk_size = nil)
      response = Atlas.client.get("#{url_builder.box_provider_url}/upload")

      chunk_size ||= Excon.defaults[:chunk_size]
      progress = 0

      chunker = lambda do
        progress += chunk_size
        yield(progress, file.size) if block_given?

        file.read(chunk_size).to_s
      end

      upload_url = response["upload_path"]
      Excon.put(upload_url, request_block: chunker)
    end

    # Delete the provider.
    #
    # @return [Hash] Atlas response object.
    def delete
      Atlas.client.delete(url_builder.box_provider_url)
    end
  end
end
