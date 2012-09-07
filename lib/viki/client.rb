require 'httparty'
require 'viki/api_object'
require 'viki/transport'
require 'viki/request'
require 'multi_json'

module Viki
  class Client
    include Viki::Transport
    HOST = "http://www.viki.com"

    def initialize(client_id, client_secret, host = nil)
      @host = host || HOST
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret, @host)
    end

    attr_reader :access_token

    private
    def method_missing(name, *args)
       raise NoMethodError if not URL_NAMESPACES.include? name
       Viki::Request.new({client_id: @client_id,
                          client_secret: @client_secret,
                          access_token: @access_token,
                          host: @host}, name, *args)
    end

  end
end
