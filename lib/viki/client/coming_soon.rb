module Viki
  class Client
    module ComingSoon
      def coming_soon
        response = request('/coming_soon')
        process_coming_soon_types(response["response"])
      end

      def coming_soon_movies
        response = request('/coming_soon/movies')
        process_coming_soon_types(response["response"], 'movie')
      end

      def coming_soon_series
        response = request('/coming_soon/series')
        process_coming_soon_types(response["response"], 'series')
      end

      private

      def process_coming_soon_types(items, type=nil)
        results = []
        items.each do |i|
          i["type"] == type if type
          Viki::ComingSoon.new(i)
        end
        results
      end
    end
  end
end
