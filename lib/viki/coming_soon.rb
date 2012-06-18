module Viki
  class ComingSoon
    def initialize(json)
      @json = json
    end

    def method_missing(attr)
      @json[attr.to_s]
    end
  end
end
