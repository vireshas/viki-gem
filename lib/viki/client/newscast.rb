module Viki
  class Client
    module Newscast
      def newscasts(params={ })
        response = request("newscasts", params)
        newscast_list = []
        response["response"].each { |newscast| newscast_list << Viki::Newscast.new(newscast) }
        newscast_list
      end

      def newscast(id, params = { })
        Viki::Newscast.new(request("newscasts/#{id}", params))
      end

      def newscast_newsclips(id, params = { })
        response = request("newscasts/#{id}/newsclips", params)
        newsclip_list = []
        response["response"].each { |newsclip| newsclip_list << Viki::Newsclip.new(newsclip) }
        newsclip_list
      end
    end
  end
end

