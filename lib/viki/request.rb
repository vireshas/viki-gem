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
      response = HTTParty.post('http://viki.com/oauth/token', query: params)
      json = MultiJson.load(response.body)
      raise Viki::Error, json["error_description"] if json["error"]
      json["access_token"]
    end

    def request(path, params = {})
      params.merge!({ :access_token => self.access_token })
      response = HTTParty.get('http://viki.com/api/v3/' + path + '.json', :query => params)
      json = MultiJson.load(response.body)
      raise Viki::Error, json["message"] if json["status"] == 404
      json
    end
  end
end
