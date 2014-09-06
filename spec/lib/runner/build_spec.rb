require "spec_helper"

describe Codescout::Runner::Build do
  let(:build) { described_class.new("http://foo", "token") }

  describe "#initialize" do
    it "initializes build" do
      expect(build.push_token).to eq "token"
      expect(build.clone_path).to eq "/tmp/token"
      expect(build.output_path).to eq "/tmp/token/codescout.json"
    end
  end

  describe "#run" do
    let(:shell) { double }

    let(:push) do
      double(
        repository: "repo",
        branch: "master",
        commit: "commit"
      )
    end

    before do
      allow(ENV).to receive(:[]).with("HOME") { "/tmp" }
      allow(File).to receive(:read).with("/tmp/token/codescout.json") { "output" }
      allow(Codescout::Runner::Shell).to receive(:new) { shell }
      allow(build.client).to receive(:fetch_push) { push }
      allow(build.client).to receive(:send_payload).with("token", "output")

      stub_shell(shell, "rm -rf /tmp/token") { true }
    end

    it "executes the build" do
      stub_shell(shell, "git clone --depth 50 --branch master repo /tmp/token") { true }
      stub_shell(shell, "cd /tmp/token && git checkout -f commit") { true }
      stub_shell(shell, "codescout /tmp/token > /tmp/token/codescout.json") { true }

      build.run
    end

    context "when git clone fails" do
      before do
        stub_shell(shell, "git clone --depth 50 --branch master repo /tmp/token") { false }
      end

      it "raises error" do
        expect { build.run }.to raise_error Codescout::Runner::BuildError, "Command failed: git clone --depth 50 --branch master repo /tmp/token"
      end
    end

    context "when git checkout fails" do
      before do
        stub_shell(shell, "git clone --depth 50 --branch master repo /tmp/token") { true }
        stub_shell(shell, "cd /tmp/token && git checkout -f commit") { false }
      end

      it "raises error" do
        expect { build.run }.to raise_error Codescout::Runner::BuildError, "Command failed: cd /tmp/token && git checkout -f commit"
      end
    end

    context "when codescout command fails" do
      before do
        stub_shell(shell, "git clone --depth 50 --branch master repo /tmp/token") { true }
        stub_shell(shell, "cd /tmp/token && git checkout -f commit") { true }
        stub_shell(shell, "codescout /tmp/token > /tmp/token/codescout.json") { false }
      end

      it "raises error" do
        expect { build.run }.to raise_error Codescout::Runner::BuildError, "Command failed: codescout /tmp/token > /tmp/token/codescout.json"
      end
    end
  end
end