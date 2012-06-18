module Viki
  class Client
    module Music_video
      def music_videos(params={ })
        response = request("music_videos", params)
        music_videos_list = []
        response["response"].each { |music_video| music_videos_list << Viki::Music_video.new(music_video) }
        music_videos_list
      end

      def music_video(id, params = { })
        Viki::Music_video.new(request("music_videos/#{id}", params))
      end
    end
  end
end

