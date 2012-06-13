require 'uri'
require 'httparty'

module Viki
  module Request
    private

    def auth_request(client_id, client_secret)
      params = {
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_secret => client_secret
      }
      response = capture HTTParty.get('http://viki.com/oauth/token', query: params).body
      response["access_token"]
      #HTTParty.post('http://www.vikiping.com/oauth/token', query: { grant_type : 'client_credentials', client_id : 'dc363b39f32aebbccbd5c80278e171d1e2a95a2582cef9ddad1c690a2cb4c652', client_secret : '4a1d38d8a1afbc12167e8471e0874c68f893d416f4aee623cb280f18fd0c072e' })
    end

    def request(http_method, path, query_params = {}, data_params = {} )
      params = {}.merge!(query_params)
      response = HTTParty.get()
    end

    #def request(http_method, path, query_params = { }, data_params = { })
    #  capture RestClient:: Request.new({
    #                                    method : http_method,
    #    url : "#{endpoint}/#{paramify(path, query_params)}",
    #    user : username,
    #    password : password
    #  }.merge(data_params)).execute
    #end

    def capture(response)
      json = Utils.parse_json(response)
      Utils.handle_error(json)
      json
    end

    def paramify(path, params)
      URI.encode("#{path}/?#{params.map { |k, v| "#{k}=#{v}" }.join('&')}")
    end

  end
end
