module Atlas
  # Representation and handling of Box Version objects.
  #
  # @attr_accessor [String] version The version number.
  # @attr_accessor [String] description Markdown test used as a full-length and
  #   in-depth description of the version.
  # @attr_accessor [String] status The status of the version
  #   (unreleased/releases) (cannot be set directly)
  # @attr_accessor [Array] providers The providers associated with this version.
  class BoxVersion < Resource
    # Properties of the version.
    attr_accessor :version, :description, :status, :providers
    date_accessor :created_at, :updated_at

    requires :version

    # Find a version by it's tag.
    #
    # @param [String] tag the tag of the version.
    #
    # @return [Version] a representation of the version.
    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_version_url)

      new(tag, response)
    end

    # Create a new version.
    #
    # @param [String] box_tag the box tag to create the version under.
    # @param [Hash] attr attributes to create the version with.
    # @param attr [String] :version The version number.
    # @param attr [String] :description Description of the box.
    #
    # @return [Version] a newly created version.
    def self.create(box_tag, attr = {})
      tag = "#{box_tag}/#{attr[:version]}"
      version = new(tag, attr)
      version.save
      version
    end

    # Initialize a version from a versiontag and object hash.
    #
    # @param [String] tag the tag which represents the origin of the version.
    # @param [Hash] hash the attributes for the version.
    # @param attr [String] :version The version number.
    # @param attr [String] :description Description of the box.
    def initialize(tag, hash = {})
      hash.replace_key!("description_markdown", "description")

      super(tag, hash)
    end

    # Assign the providers of this version.
    #
    # @note This is intended to be used to assign the response object, not
    #   calling directly.
    #
    # @param [Array] attr an array of response hashes.
    def providers=(attr)
      @providers = attr.collect do |v|
        BoxProvider.new("#{tag}/#{v['name']}", v)
      end
    end

    # Create a provider for this version.
    #
    # @param [Hash] attr attributes for the provider.
    #
    # @return [BoxProvider] a representation of the provider.
    def create_provider(attr)
      BoxProvider.create(tag, attr)
    end

    # Save the version.
    #
    # @return [Hash] Atlas response object.
    def save # rubocop:disable Metrics/AbcSize
      body = { version: to_hash }

      # providers are saved seperately
      body[:version].delete(:providers)

      begin
        response = Atlas.client.put(url_builder.box_version_url, body: body)
      rescue Atlas::Errors::NotFoundError
        response = Atlas.client.post("#{url_builder.box_url}/versions",
                                     body: body)
      end

      # trigger the same on the providers
      providers.each(&:save) if providers

      update_with_response(response, [:providers])
    end

    # Release the version.
    #
    # @return [Hash] Atlas response object.
    def release
      response = Atlas.client.put("#{url_builder.box_version_url}/release")

      update_with_response(response)
    end

    # Revoke the version.
    #
    # @return [Hash] Atlas response object.
    def revoke
      response = Atlas.client.put("#{url_builder.box_version_url}/revoke")

      update_with_response(response)
    end

    # Delete the version.
    #
    # @return [Hash] Atlas response object.
    def delete
      Atlas.client.delete(url_builder.box_version_url)
    end
  end
end
