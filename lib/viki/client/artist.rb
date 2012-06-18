module Viki
  class Client
    module Artist
      def artists(params={ })
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
        response = request("artists", params)
        artist_list = []
        response["response"].each { |artist| artist_list << Viki::Artist.new(artist) }
        artist_list
      end

      def artist(id, params = { })
        Viki::Artist.new(request("artists/#{id}", params))
      end

      def artist_music_videos(id, params = { })
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
        response = request("artists/#{id}/music_videos", params)
        music_video_list = []
        response["response"].each { |music_video| music_video_list << Viki::MusicVideo.new(music_video) }
        music_video_list
      end
    end
  end
end

