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
    end
  end
end

