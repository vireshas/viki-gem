module Viki
  class Client
    module Movies
      def movies(params = { })
        # hack until API is fixed, should return API error message
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
        response = request("movies", params)
        movie_list = []
        response["response"].each { |movie| movie_list << Movie.new(movie) }
        movie_list
      end

      def movie(id, params = { })
        Movie.new(request("movies/#{id}", params))
      end

      def movie_subtitles(id, lang)
        request("movies/#{id}/subtitles/#{lang}")
      end

      def movie_hardsubs(id)
        request("movies/#{id}/hardsubs")
      end

    end
  end
end

