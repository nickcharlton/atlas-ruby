module Atlas
  # Representation and handling of Box objects.
  class Box < Resource
    attr_accessor :name, :username, :short_description, :description,
                  :is_private, :current_version, :versions

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

    def initialize(tag, hash = {})
      hash['is_private'] = hash['private']
      hash['description'] = hash['description_markdown']

      super(tag, hash)
    end

    def current_version=(attr)
      if attr.is_a? Hash
        @current_version = BoxVersion.new("#{tag}/#{attr['version']}", attr)
      else
        @current_version = attr
      end
    end

    def versions=(attr)
      @versions = attr.collect do |v|
        BoxVersion.new("#{tag}/#{v['version']}", v)
      end
    end

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
