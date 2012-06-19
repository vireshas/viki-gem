require 'multi_json'

module Viki
  class APIObject
    def initialize(json)
      hash = MultiJson.load(json)
      puts "===> hash: #{(hash).inspect}"
      @content = hash["response"]
      @count = hash["count"] # may return nil
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

    #def method_missing(attr)
    #  @json[attr.to_s]
    #end
  end
end
