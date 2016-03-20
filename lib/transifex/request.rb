require 'faraday'
require 'faraday_middleware'

module Transifex
  module Request
    def set_credentials(username, password)
      @username = username
      @password = password
    end

    def connection
      @connection ||= make_connection(@username, @password)
    end

    def get(path, params = {})
      make_request(:get, path, params)
    end

    def post(path, params = {})
      make_request(:post, path, params)
    end

    def put(path, params = {})
      make_request(:put, path, params)
    end

    def delete(path, params = {})
      make_request(:delete, path, params)
    end

    private

    def make_request(verb, path, params = {})
      response = connection.send(verb, build_path(:v2, path), params)
      response.body
    end

    def build_path(version, path)
      "/api/2/#{path}"
    end

    def make_connection(username, password)
      options = {
        headers: {
          'Accept' => 'application/json',
          'User-Agent' => Transifex::Config::USER_AGENT,
        },
        url: Transifex::Config::BASE_URL
      }

      Faraday.new(options) do |builder|
        builder.use FaradayMiddleware::Mashify
        builder.use Faraday::Response::ParseJson, content_type: /\bjson$/
        builder.use Transifex::Middleware::RaiseHttpErrors
        builder.use(FaradayMiddleware::FollowRedirects)

        # Authentiation
        builder.basic_auth(username, password)

        # Request Middleware
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded

        builder.adapter :net_http
      end
    end
  end
end
