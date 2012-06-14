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

    def movies(id = nil)
      if id
        Movie.new(request("movies/#{id}", { :access_token => self.access_token }))
      else
        response = request("movies", { :access_token => self.access_token })
        movie_list = []
        response["response"].each { |movie| movie_list << Movie.new(movie) }
        movie_list
      end

    end

  end
end
