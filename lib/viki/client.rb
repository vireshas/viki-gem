require 'httparty'
require 'viki/api_object'
require 'viki/transport'
require 'viki/request'
require 'multi_json'

module Viki
  class Client
    include Viki::Transport

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
    end

    attr_reader :access_token

    private
    def method_missing(name, *args)
       raise NoMethodError if not URL_NAMESPACES.include? name
       Viki::Request.new({client_id: @client_id,
                          client_secret: @client_secret,
                          access_token: @access_token}, name, *args)
    end

  end
end
