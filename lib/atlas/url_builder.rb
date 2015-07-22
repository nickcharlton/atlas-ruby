module Atlas
  # A class which takes (and extends) Atlas tags and builds URLs from them.
  #
  # This allows us to refer to items using the same identifiers as Vagrant, with
  # a few extras.
  class UrlBuilder
    attr_reader :tag

    def initialize(tag)
      user, box, version, provider = tag.split(%r{\/})

      @tag = { user: user, box: box, version: version, provider: provider }
    end

    def url_for(user = nil, box = nil, version = nil, provider = nil)
      url = ''

      if user && !box
        return  "/user/#{user}"
      else
        url << "/box/#{user}"
      end

      url << "/#{box}" if box
      url << "/version/#{version}" if version
      url << "/provider/#{provider}" if provider

      url
    end

    { user: [:user],
      box: [:user, :box],
      box_version: [:user, :box, :version],
      box_provider: [:user, :box, :version, :provider] }.each do |m, a|
      define_method "#{m}_url" do
        a.each { |e| return nil unless tag[e] }

        url_for(*tag.values_at(*a))
      end
    end
  end
end
