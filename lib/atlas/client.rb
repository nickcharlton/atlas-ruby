module Atlas
  # Client for interacting with the Atlas API.
  class Client
    DEFAULT_HEADERS = { 'User-Agent' => "Atlas-Ruby/#{Atlas::VERSION}",
                        'Content-Type' => 'application/json' }

    attr_accessor :url

    def initialize(opts = {})
      @url = opts[:url] || 'https://atlas.hashicorp.com'
      @access_token = opts[:access_token]
    end

    def get(url, opts = {})
      request(:get, url, opts)
    end

    private

    def request(method, path, opts = {})
      body, query, headers = parse_opts(opts)

      # set the default headers
      headers.merge!(DEFAULT_HEADERS)

      # set the access token
      query.merge!(access_token: @access_token)

      connection = Excon.new(@url)
      connection.request(method: method, path: "/api/v1#{path}",
                         body: body, query: query, headers: headers)
    end

    def parse_opts(opts)
      body = opts.fetch(:body, nil)
      body = JSON.dump(body) if body && body.is_a?(Hash)

      query = opts.fetch(:query, {})
      headers = opts.fetch(:headers, {})

      [body, query, headers]
    end
  end
end
