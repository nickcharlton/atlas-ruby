module Atlas
  # Representation and handling of User objects.
  class User
    attr_accessor :username, :avatar_url, :profile_html, :profile_markdown,
                  :boxes

    def self.load(name)
      response = Atlas.client.get("/user/#{name}")

      from_json(JSON.parse(response.body))
    end

    def self.from_json(json)
      user = new
      user.username = json['username']
      user.avatar_url = json['avatar_url']
      user.profile_html = json['profile_html']
      user.profile_markdown = json['profile_markdown']
      user.boxes = json['boxes'].collect { |box| Box.from_json(box) }

      user
    end
  end
end
