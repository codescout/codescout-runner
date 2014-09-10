require "spec_helper"

describe Codescout::Runner::Shell do
  let(:shell) { described_class.new }

  describe "#execute" do
    it "returns true on success" do
      expect(shell.execute("date")).to eq true
    end

    it "returns false on failure" do
      expect(shell.execute("mkdir /tmp")).to eq false
    end
  end
end