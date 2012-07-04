module Viki
  module Utilities
    private

    def capture(response)
      raise Viki::Error.new("408", "Timeout error") if response.header.code == "408"
      if response.header.code != "200"
        response_hash = MultiJson.load(response.body)
        raise Viki::Error.new(response.header.code, response_hash["message"]) if response.header.code != "200"
      end
    end

  end
end
