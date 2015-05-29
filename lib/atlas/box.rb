module Atlas
  # Representation and handling of Box objects.
  class Box < Resource
    attr_accessor :name, :username, :short_description, :description,
                  :is_private, :current_version, :versions

    def self.load(username, name)
      response = Atlas.client.get("/box/#{username}/#{name}")

      new(JSON.parse(response.body))
    end

    def initialize(hash = {})
      hash['is_private'] = hash['private']
      hash['description'] = hash['description_markdown']

      super(hash)
    end

    def current_version=(hash)
      @current_version = BoxVersion.new(
        { origin: { username: username, box_name: name } }.merge(hash)
      ) if hash.is_a? Hash
    end

    def versions=(hash)
      @versions = hash.collect do |v|
        BoxVersion.new(
          { origin: { username: username, box_name: name } }.merge(v)
        )
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
