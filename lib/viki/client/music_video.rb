module Viki
  class Client
    module MusicVideo
      def music_videos(params={ })
        raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
        response = request("music_videos", params)
        music_videos_list = []
        response["response"].each { |music_video| music_videos_list << Viki::MusicVideo.new(music_video) }
        music_videos_list
      end

      def music_video(id, params = { })
        Viki::MusicVideo.new(request("music_videos/#{id}", params))
      end
    end
  end
end

