require 'httparty'
require 'viki/request'

module Viki
  class Client

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
    end

    attr_reader :access_token

    include Viki::Request

  end
end
