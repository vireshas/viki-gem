module Viki
  module Utilities
    private

    def capture(response)
      if response.header.code != "200"
        response_hash = MultiJson.load(response.body)
        raise Viki::Error.new(response.header.code, response_hash["message"]) if response.header.code != "200"
      end
    end

  end
end
