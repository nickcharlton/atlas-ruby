module Atlas
  # Representation and handling of Box Version objects.
  class BoxVersion
    attr_accessor :version, :status, :description_html, :description_markdown,
                  :number, :release_url, :revoke_url, :providers, :created_at,
                  :updated_at

    def self.load(username, name, version)
      response = Atlas.client.get("/box/#{username}/#{name}/version/#{version}")

      from_json(JSON.parse(response.body))
    end

    def self.from_json(json)
      version = new
      version.version = json['version']
      version.status = json['status']
      version.description_html = json['description_html']
      version.description_markdown = json['description_markdown']
      version.number = json['number']
      version.release_url = json['release_url']
      version.revoke_url = json['revoke_url']
      version.created_at = json['created_at']
      version.updated_at = json['updated_at']

      if json['providers']
        version.providers = json['providers'].collect do |p|
          BoxProvider.from_json(p)
        end
      end

      version
    end
  end
end
