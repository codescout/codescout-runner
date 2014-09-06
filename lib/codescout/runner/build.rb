module Codescout::Runner
  class Build
    attr_reader :client, :push_token, :push
    attr_reader :clone_path, :output_path

    def initialize(service_url, push_token)
      @shell       = Codescout::Runner::Shell.new
      @client      = Codescout::Runner::Client.new(service_url)
      @push_token  = push_token
      @clone_path  = "/tmp/#{@push_token}"
      @output_path = "#{@clone_path}/codescout.json"
    end

    def run
      cleanup
      fetch_push
      setup_ssh_keys
      clone_repository
      generate_report
      submit_report
    end

    private

    def cleanup
      shell("rm -rf #{clone_path}")
    end

    def fetch_push
      @push = client.fetch_push(push_token)
    end

    def setup_ssh_keys
      # No need to install ssh keys for public repos
      return unless @push.repository =~ /git@/

      Codescout::Runner::Key.new(@push.public_key, @push.private_key).install
    end
    
    def clone_repository
      branch = push.branch
      repo   = push.repository

      shell("git clone --depth 50 --branch #{branch} #{repo} #{clone_path}")
      shell("cd #{clone_path} && git checkout -f #{push.commit}")
    end

    def generate_report
      shell("codescout #{clone_path} > #{output_path}")
    end

    def submit_report
      client.send_payload(push_token, File.read(output_path))
    end

    def shell(command)
      result = @shell.execute(command)

      if !result
        message = "Command failed: #{command}"
        raise Codescout::Runner::BuildError, message
      end
    end
  end
end