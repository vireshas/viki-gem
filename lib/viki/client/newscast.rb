module Viki
  class Client
    module Newscast
      def newscasts(params={ })
        response = request("series", params)
        newscast_list = []
        response["response"].each { |newscast| newscast_list << Viki::Newscast.new(newscast) }
        newscast_list
      end

      def newscast(id, params = { })
        Viki::Newscast.new(request("newscasts/#{id}", params))
      end
    end
  end
end

