module Atlas
  # A collection of errors which can be raised by this gem.
  module Errors
    # Base error for all other gem errors.
    class AtlasError < StandardError; end

    # Raised when a resource cannot be validated.
    class InvalidResourceError < AtlasError; end

    # Raised when incorrect arguments are provided to a method.
    class ArgumentError < AtlasError; end

    # Raised when a request returns a 400 Bad Request.
    class ClientError < AtlasError; end

    # Raised when a request returns a 401 Unauthorized.
    class UnauthorizedError < AtlasError; end

    # Raised when a request returns a 404 Not Found.
    class NotFoundError < AtlasError; end

    # Raised when a request returns a 500 Server Error.
    class ServerError < AtlasError; end

    # Raised when a request times out.
    class TimeoutError < AtlasError; end
  end
end
