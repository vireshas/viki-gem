module Viki
  class Client
    module Newsclip
      def newsclips(params={})
        response = request("newsclips", params)
        newsclip_list = []
        response["response"].each { |newsclip| newsclip_list << Viki::Newsclip.new(newsclip) }
        newsclip_list
      end

      def newsclip(id, params = {})
        Viki::Newsclip.new(request("newsclips/#{id}", params))
      end

      def newsclip_subtitles(id, lang)
        request("newsclips/#{id}/subtitles/#{lang}")
      end

      def newsclip_hardsubs(id)
        request("newsclips/#{id}/hardsubs")
      end
    end
  end
end
