require 'transifex/http_error'
require 'faraday_middleware'

module Transifex
  module Middleware
    class RaiseHttpErrors < Faraday::Response::Middleware
      def call(env)
        @app.call(env).on_complete do |response|
          resp = response[:response]
          status = response[:status].to_i

          case status
            when 400
              raise Transifex::BadRequest.new(resp)
            when 401
              raise Transifex::Unauthorized.new(resp)
            when 403
              raise Transifex::Forbidden.new(resp)
            when 404
              raise Transifex::NotFound.new(resp)
            when 406
              raise Transifex::NotAcceptable.new(resp)
            when 409
              raise Transifex::Conflict.new(resp)
            when 415
              raise Transifex::UnsupportedMediaType.new(resp)
            when 422
              raise Transifex::UnprocessableEntity.new(resp)
          end

          if (status / 100) != 2
            raise Transifex::HttpError.new(resp)
          end
        end
      end
    end
  end
end
