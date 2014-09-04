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
      json     = JSON.load(response.body)

      Hashie::Mash.new(json)
    end

    def send_payload(token, payload)
      connection.post("/worker/payload/#{token}", payload) do |c|
        c.headers["Content-Type"] = "text/plain"
      end
    end

    private

    def connection
      @connection ||= Faraday.new(@url) do |c|
        c.use(Faraday::Request::UrlEncoded)
        c.adapter(Faraday.default_adapter)
      end
    end
  end
end