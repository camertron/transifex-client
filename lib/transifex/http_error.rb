module Transifex
  class HttpError < StandardError
    attr_accessor :response

    def initialize(response = nil)
      @response = response
      super
    end
  end

  class BadRequest < HttpError; end
  class Unauthorized < HttpError; end
  class Forbidden < HttpError; end
  class NotFound < HttpError; end
  class NotAcceptable < HttpError; end
  class Conflict < HttpError; end
  class UnsupportedMediaType < HttpError; end
  class UnprocessableEntity < HttpError; end
end
