module Atlas
  # Representation and handling of Box objects.
  class Box
    attr_accessor :name, :tag, :short_description, :description_markdown,
                  :description_html, :username, :private, :created_at,
                  :updated_at, :current_version, :versions

    def self.load(username, name)
      response = Atlas.client.get("/box/#{username}/#{name}")

      from_json(JSON.parse(response.body))
    end

    def self.from_json(json)
      box = new
      box.name = json['name']
      box.tag = json['tag']
      box.short_description = json['short_description']
      box.description_markdown = json['description_markdown']
      box.description_html = json['description_html']
      box.username = json['username']
      box.private = json['private']
      box.created_at = json['created_at']
      box.updated_at = json['updated_at']

      if json['current_version']
        box.current_version = BoxVersion.from_json(json['current_version'])
      end

      if json['versions']
        box.versions = json['versions'].collect { |v| BoxVersion.from_json(v) }
      end

      box
    end
  end
end
