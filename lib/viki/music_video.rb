module Viki
  class Music_video

    def initialize(json)
      @json = json
    end

    def method_missing(attr)
      @json[attr.to_s]
    end

  end
end
