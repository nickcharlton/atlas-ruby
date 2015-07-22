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
        response = Atlas.client.put("/box/#{username}/#{name}", body: body)
      rescue Excon::Errors::NotFound
        response = Atlas.client.post('/boxes', body: body)
      end

      # trigger the same on versions
      versions.each(&:save) if versions

      update_with_response(response.body, [:versions])
    end
  end
end
