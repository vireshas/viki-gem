require 'multi_json'
require 'viki/request'

module Viki
  class APIObject
    include Viki::Request

    def initialize(json)
      hash = MultiJson.load(json)

      hash.has_key?("response") ?  @content = hash["response"] : @content = hash
      hash.has_key?("count") ? @count = hash["count"].to_i : @count = 1

      @next_url =       hash["pagination"]["next"] if hash["pagination"]
      @previous_url =   hash["pagination"]["previous"] if hash["pagination"]
    end

    attr_reader :content, :count

    def next
      if @next_url
        direct_request(@next_url)
      else
        nil
      end
    end

    def prev
      @previous_url
    end
  end
end
