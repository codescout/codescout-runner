module Codescout::Runner
  class Key
    def initialize(public_key, private_key)
      @public_key  = public_key
      @private_key = private_key
    end

    def install
      return if keys_installed?

      write(private_key_path, @private_key)
      write(public_key_path, @public_key)
    end

    private

    def keys_installed?
      installed?(private_key_path) && installed?(public_key_path)
    end

    def home_path
      ENV["HOME"]
    end

    def private_key_path
      File.join(home_path, ".ssh/id_rsa")
    end

    def public_key_path
      File.join(home_path, ".ssh/id_rsa.pub")
    end

    def write(path, content)
      File.open(path, "w") { |f| f.write(content) }
    end

    def installed?(path)
      File.exists?(path) && File.size(path) > 0
    end
  end
end