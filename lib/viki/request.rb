require 'uri'
require 'httparty'
require 'multi_json'


module Viki
  module Request
    private
    def auth_request(client_id, client_secret)
      params = {
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_secret => client_secret
      }
      response = HTTParty.post('http://vikiping.com/oauth/token', query: params).body
      json = MultiJson.load(response)
      raise Viki::Error, json["error_description"] if json["error"]
      json["access_token"]
    end

    #def request(http_method, path, query_params = {}, data_params = {} )
    #  params = {}.merge!(query_params)
    #  response = HTTParty.get()
    #end

    #def paramify(path, params)
    #  URI.encode("#{path}/?#{params.map { |k, v| "#{k}=#{v}" }.join('&')}")
    #end

  end
end
