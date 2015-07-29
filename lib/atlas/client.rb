module Atlas
  # Client for interacting with the Atlas API.
  class Client
    include Atlas::Errors

    DEFAULT_HEADERS = { 'User-Agent' => "Atlas-Ruby/#{Atlas::VERSION}",
                        'Content-Type' => 'application/json' }

    attr_accessor :url

    def initialize(opts = {})
      @url = opts[:url] || 'https://atlas.hashicorp.com'
      @access_token = opts[:access_token]
    end

    %w(get put post delete).each do |m|
      define_method m do |path, opts = {}|
        request(m.to_sym, path, opts)
      end
    end

    private

    def request(method, path, opts = {}) # rubocop:disable AbcSize, MethodLength
      body, query, headers = parse_opts(opts)

      # set the default headers
      headers.merge!(DEFAULT_HEADERS)

      # set the access token
      query.merge!(access_token: @access_token)

      connection = Excon.new(@url)
      connection.request(expects: [200, 201], method: method,
                         path: "/api/v1#{path}", body: body, query: query,
                         headers: headers)

    rescue Excon::Errors::BadRequest => e
      raise ClientError, e.response.body
    rescue Excon::Errors::Unauthorized => e
      raise UnauthorizedError, e.response.body
    rescue Excon::Errors::NotFound => e
      raise NotFoundError, e.response.body
    rescue Excon::Errors::InternalServerError => e
      raise ServerError, e.response.body
    rescue Excon::Errors::Timeout => e
      raise TimeoutError, e.message
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
