require 'multi_json'
require 'viki/utilities'

module Viki
  class APIObject
    include Viki::Utilities

    def initialize(json, access_token)
      hash = MultiJson.load(json)
      @content = hash["response"] ?  hash["response"] : hash
      @count =  hash["count"] ? hash["count"].to_i : 1

      pagination = hash["pagination"]

      if pagination
        @next_url = pagination["next"] if not pagination["next"].empty?
        @previous_url = pagination["previous"] if not pagination["previous"].empty?
      end

      @access_token = access_token
    end

    attr_reader :content, :count

    def next
      @next_url ? direct_request(@next_url) : nil
    end

    def prev
      @previous_url ? direct_request(@next_url) : nil
    end

    private

    def direct_request(url)
      response = HTTParty.get(url, :query => { access_token: @access_token })
      capture response
      APIObject.new(response.body, @access_token)
    end
  end
end
