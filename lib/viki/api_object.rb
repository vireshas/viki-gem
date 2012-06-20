require 'multi_json'
require 'viki/request'

module Viki
  class APIObject
    include Viki::Request

    def initialize(json, access_token)
      hash = MultiJson.load(json)
      hash["response"] ? @content = hash["response"] : @content = hash
      hash["count"] ? @count = hash["count"].to_i : @count = 1

      pagination = hash["pagination"]
      if pagination
        @next_url = pagination["next"] if not pagination["next"].empty?
        @previous_url = pagination["previous"] if not pagination["previous"].empty?
      end

      @access_token = access_token
    end

    attr_reader :content, :count

    def next
      @next_url ? direct_request(@next_url, @access_token) : nil
    end

    def prev
      @previous_url ? direct_request(@next_url, @access_token) : nil
    end

  end
end
