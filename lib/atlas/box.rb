module Atlas
  # Representation and handling of Box objects.
  #
  # @attr_accessor [String] name The name of the box
  # @attr_accessor [String] username The owner of the box
  # @attr_accessor [String] short_description A short version of the
  #   description.
  # @attr_accessor [String] description Markdown text used to describe it.
  # @attr_accessor [Boolean] is_private A boolean if the box is private.
  # @attr_accessor [Version] current_version the current version of this box.
  # @attr_accessor [Array] versions versions associated with this box.
  class Box < Resource
    attr_accessor :name, :username, :short_description, :description,
                  :is_private, :current_version, :versions

    # Find a box by it's tag.
    #
    # @param [String] tag the tag of the box.
    #
    # @return [Box] a representation of the box.
    def self.find(tag)
      url_builder = UrlBuilder.new tag
      response = Atlas.client.get(url_builder.box_url)

      new(tag, JSON.parse(response.body))
    end

    # Create a new Box.
    #
    # @param [Hash] attr attributes to create the box with
    # @param attr [String] :name The name of the box, used to identify it.
    # @option attr [String] :username The username to assign the box to.
    # @option attr [String] :short_description The short description is used on
    #   small box previews.
    # @option attr [String] :description Markdown text used as a full-length and
    #   in-depth description of the box.
    # @option attr [Boolean] :is_private A boolean if the box should be private
    #   or not.
    #
    # @return [Box] a newly created box.
    def self.create(attr = {})
      tag = "#{attr.fetch(:username, '')}/#{attr[:name]}"
      box = new(tag, attr)
      box.save
      box
    end

    # Initialize a box from a tag and object hash.
    #
    # @param [String] tag the tag which represents the origin of the box.
    # @param [Hash] hash the attributes for the box
    # @param hash [String] :name The name of the box, used to identify it.
    # @option hash [String] :username The username to assign the box to.
    # @option hash [String] :short_description The short description is used on
    #   small box previews.
    # @option hash [String] :description Markdown text used as a full-length and
    #   in-depth description of the box.
    # @option hash [Boolean] :is_private A boolean if the box should be private
    #   or not.
    #
    # @return [Box] a new box object.
    def initialize(tag, hash = {})
      hash['is_private'] = hash['private']
      hash['description'] = hash['description_markdown']

      super(tag, hash)
    end

    # Assign the current version.
    #
    # @note This is intended to be used to assign the response object, not
    #   calling directly. Calling `release` will set the `current_version`.
    #
    # @param [Hash] attr a response hash of a `BoxVersion`.
    def current_version=(attr)
      if attr.is_a? Hash
        @current_version = BoxVersion.new("#{tag}/#{attr['version']}", attr)
      else
        @current_version = attr
      end
    end

    # Assign the versions of this box.
    #
    # @note This is intended to be used to assign the response object, not
    #   calling directly. You could do something unexpected by replacing this.
    #
    # @param [Array] attr an array of responses hashes.
    def versions=(attr)
      @versions = attr.collect do |v|
        BoxVersion.new("#{tag}/#{v['version']}", v)
      end
    end

    # Save the box.
    #
    # @return [Hash] Atlas response object.
    def save
      body = { box: to_hash }

      # versions are saved seperately
      body[:box].delete(:versions)

      # update or create the box
      begin
        response = Atlas.client.put(url_builder.box_url, body: body)
      rescue Excon::Errors::NotFound
        response = Atlas.client.post('/boxes', body: body)
      end

      # trigger the same on versions
      versions.each(&:save) if versions

      update_with_response(response.body, [:versions])
    end

    # Delete the box.
    #
    # @return [Hash] response body from Atlas.
    def delete
      response = Atlas.client.delete(url_builder.box_url)

      JSON.parse(response.body)
    end
  end
end
