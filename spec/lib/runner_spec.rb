require "spec_helper"

describe Codescout::Runner do
  describe ".perform" do
    let(:build) { double }

    before do
      allow(build).to receive(:run)
      allow(Codescout::Runner::Build).to receive(:new) { build }

      described_class.perform("url", "token")
    end

    it "executes a build" do
      expect(build).to have_received(:run)
    end
  end
end