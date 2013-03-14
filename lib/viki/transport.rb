require 'uri'
require 'httparty'
require 'multi_json'
require 'viki/utilities'

module Viki
  module Transport
    include Viki::Utilities

    private

    def auth_request(client_id, client_secret, host)
      endpoint = host + '/oauth/token'
      params = {
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_secret => client_secret
      }

      puts " requesting:: #{endpoint} with params:: #{params.inspect}"

      response = HTTParty.post(endpoint, query: params)
      json = MultiJson.load(response.body)
      raise Viki::Error.new(response.header.code, json["error_description"]) if response.header.code != "200"
      json["access_token"]
    end

    def request(call_chain, host)
      path, params = build_url(call_chain)
      request_url = host + "/api/v3/" + path.chop + ".json"

      response = HTTParty.get(request_url, :query => params)

      if response.header.code == "401"
        self.reset_access_token
        params.merge!({ access_token: self.access_token })
        response = HTTParty.get(request_url, :query => params)
      end

      capture response

      APIObject.new(response.body, self.access_token)
    end

    def build_url(call_chain)
      path = ""
      params = { access_token: self.access_token }

      call_chain.each do |c|
        path += "#{c[:name]}/"
        path += "#{c[:resource]}/" if c.has_key?(:resource)
        params.merge!(c[:params]) if c.has_key?(:params)
      end

      return path, params
    end
  end
end
