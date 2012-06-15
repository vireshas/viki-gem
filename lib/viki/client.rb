require 'httparty'
require 'viki/request'
require 'viki/movie'

module Viki
  class Client

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
    end

    attr_reader :access_token

    include Viki::Request

    def movies(params = {})
      #hack until API is fixed, then return API error message
      raise Viki::Error, "A watchable_in parameter is required when using the platform parameter" if params[:platform] && !params[:watchable_in]
      response = request("movies", params)
      movie_list = []
      response["response"].each { |movie| movie_list << Movie.new(movie) }
      movie_list
    end

    def movie(id, params = {})
      Movie.new(request("movies/#{id}", params))
    end
  end
end
