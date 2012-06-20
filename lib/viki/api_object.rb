require 'multi_json'

module Viki
  class APIObject
    def initialize(json)
      hash = MultiJson.load(json)
      hash["response"] ? @content = hash["response"] : @content = hash
      @count = hash["count"] if hash["count"]
      @next_url = hash["pagination"]["next"] if hash["pagination"]
      @previous_url = hash["pagination"]["previous"] if hash["pagination"]
    end

    attr_reader :content, :count

    def next
      @next_url
    end

    def prev
      @previous_url
    end
  end
end
