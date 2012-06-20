require 'uri'
require 'httparty'
require 'multi_json'


module Viki
  module Request

    private
    HOST = "http://www.viki.com/api/v3/"

    def auth_request(client_id, client_secret)
      params = {
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_secret => client_secret
      }
      response = HTTParty.post('http://viki.com/oauth/token', query: params)
      json = MultiJson.load(response.body)
      raise Viki::Error, json["error_description"] if json["error"]
      json["access_token"]
    end

    def request(call_chain)
      path = ""
      params = { access_token: self.access_token }

      call_chain.each do |c|
        path += "#{c[:name]}/"
        path += "#{c[:resource]}/" if c.has_key?(:resource)
        params.merge!(c[:params]) if c.has_key?(:params)
      end

      response = HTTParty.get(HOST + path.chop + ".json", :query => params)
      capture response
      APIObject.new(response.body)
    end

    def capture(response)
      if response.header.code != "200"
        response_hash = MultiJson.load(response.body)
        raise Viki::Error, response_hash["message"]
      end
    end
  end
end
