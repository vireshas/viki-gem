module Viki
  class Client
    module Newscast
      def newscasts(params={ })
        response = request("series", params)
        series_list = []
        response["response"].each { |newscast| series_list << Viki::Newscast.new(newscast) }
        series_list
      end

      def newscast(id, params = { })
        Viki::Newscast.new(request("newscasts/#{id}", params))
      end
    end
  end
end

