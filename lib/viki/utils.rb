require 'multi_json'

module Viki
  # @private
  module Utils
    private 
      def self.handle_error(json_response)
        raise Viki::Error.new(json_response) if (json_response['status'] != 'ok')
      end
      
      # Parses JSON and returns a Hash
      def self.parse_json(json)
        MultiJson.load(json)
      end
  end
end
