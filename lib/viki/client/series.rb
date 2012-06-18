module Viki
  class Client
    module Series
      def series(id = nil, params={ })
        params = id if id.is_a?(Hash)

        # hack until API is fixed, should return API error message
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]

        if id.is_a?(Integer)
          Viki::Series.new(request("series/#{id}", params))
        else
          response = request("series", params)
          series_list = []
          response["response"].each { |movie| series_list << Viki::Series.new(movie) }
          series_list
        end
      end

      def series_episodes(series_id)
        response = request("series/#{series_id}/episodes")
        episode_list = []
        response["response"].each { |episode| episode_list << Episode.new(episode) }
        episode_list
      end

      def series_episode(episode_id, params = { })
        response = request("series/#{params[:series]}/episodes/#{episode_id}")
        Episode.new(response)
      end
    end
  end
end
