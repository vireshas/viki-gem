require 'httparty'
require 'viki/request'
require 'viki/movie'
require 'viki/series'
require 'viki/episode'
require 'viki/newscast'
require 'viki/music_video'
require 'viki/artist'
require 'viki/coming_soon'

module Viki
  class Client
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
    end

    attr_reader :access_token

    include Viki::Request
    include Viki::Client::Movies
    include Viki::Client::Series
    include Viki::Client::Newscast
    include Viki::Client::MusicVideo
    include Viki::Client::Artist
    include Viki::Client::ComingSoon
    include Viki::Client::Featured

  end
end
