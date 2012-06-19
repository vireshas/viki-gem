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
    end
  end
end
