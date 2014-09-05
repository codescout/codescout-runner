module Codescout::Runner
  class Key
    def initialize(public_key, private_key)
      @public_key  = public_key
      @private_key = private_key
    end

    def install
      write(@private_key, private_key_path)
      write(@public_key, public_key_path)
    end

    private

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
  end
end