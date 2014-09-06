require "spec_helper"

describe Codescout::Runner::Client do
  let(:client) { described_class.new("http://foo") }

  describe "#fetch_push" do
    context "when connection failed" do
      before do
        allow_any_instance_of(Faraday::Connection).to receive(:get) do
          raise Faraday::ConnectionFailed, "Refused"
        end
      end

      it "raises error" do
        expect { client.fetch_push("bar") }.
          to raise_error Codescout::Runner::ClientError
      end
    end

    context "when push token is invalid" do
      before do
        stub_request(:get, "http://foo/worker/push/bar").
          with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v0.9.0'
          }).
          to_return(
            status: 400, body: fixture("invalid_token.json"), headers: {}
          )
      end

      it "raises error" do
        expect { client.fetch_push("bar") }.
          to raise_error Codescout::Runner::ClientError
      end
    end

    context "when push token is valid" do
      let(:result) { client.fetch_push("bar") }

      before do
        stub_request(:get, "http://foo/worker/push/bar").
          with(headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v0.9.0'
          }).
          to_return(
            status: 200, body: fixture("push.json"), headers: {}
          )
      end

      it "returns a hashie object" do
        expect(result).to be_a Hashie::Mash
        expect(result.repository).to eq "https://github.com/foo/bar.git"
        expect(result.branch).to eq "master"
        expect(result.commit).to eq "master"
        expect(result.private_key).to eq "private"
        expect(result.public_key).to eq "public"
      end
    end
  end
end