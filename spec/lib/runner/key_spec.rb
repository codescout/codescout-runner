require "spec_helper"

describe Codescout::Runner::Key do
  let(:private_key) { "private" }
  let(:public_key)  { "public"  }

  let(:key) do
    described_class.new(public_key, private_key)
  end

  before(:all) do
    FileUtils.mkdir_p("/tmp/.ssh")
  end

  before do
    allow(ENV).to receive(:[]).with("HOME") { "/tmp" }
  end

  after(:all) do
    FileUtils.rm_rf("/tmp/.ssh")
  end

  describe "#install" do
    before { key.install }

    it "writes private key" do
      expect(File.read("/tmp/.ssh/id_rsa")).to eq private_key
    end

    it "write public key" do
      expect(File.read("/tmp/.ssh/id_rsa.pub")).to eq public_key
    end
  end
end