require "faraday"
require "json"
require "hashie"

module Codescout::Runner
  class Client
    def initialize(url)
      @url = url
    end

    def fetch_push(token)
      response = connection.get("/worker/push/#{token}")
      json = JSON.load(response.body)
      obj = Hashie::Mash.new(json)

      if obj.error
        raise Codescout::Runner::ClientError, obj.error
      end

      obj

    rescue JSON::ParserError => err
      raise Codescout::Runner::ClientError, err.message
    rescue Faraday::ConnectionFailed => err
      raise Codescout::Runner::ClientError, err.message
    end

    def send_payload(token, payload)
      connection.post("/worker/payload/#{token}", payload) do |c|
        c.headers["Content-Type"] = "text/plain"
      end
    end

    def connection
      @connection ||= Faraday.new(@url) do |c|
        c.use(Faraday::Request::UrlEncoded)
        c.adapter(Faraday.default_adapter)
      end
    end
  end
end