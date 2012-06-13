require 'httparty'
# Adapted from the Ruby Twitter gem.
# @see https://github.com/jnunemaker/twitter
module Viki
  # Defines constants and methods related to configuration.
  module Configuration
    # An array of valid keys in the options hash when configuring a {Flixated::API}.
    VALID_OPTIONS_KEYS = [
      :client_id,
      :client_secret,
      :access_token
    ].freeze

    # By default, don't set a client id.
    DEFAULT_CLIENT_ID = nil.freeze

    # By default, don't set a client secret.
    DEFAULT_CLIENT_SECRET = nil.freeze

    # By default, don't set an access token.
    DEFAULT_ACCESS_TOKEN = nil.freeze

    # @private
    attr_accessor(*VALID_OPTIONS_KEYS)

    # When this module is extended, set all configuration options to their default values.
    def self.extended(base)
      base.reset
    end

    def auth_request(client_id, client_secret)
      params = {
        :grant_type => 'client_credentials',
        :client_id => client_id,
        :client_secret => client_secret
      }
      response = HTTParty.post('http://vikiping.com/oauth/token', query: params).body
      json = Utils.parse_json(response)
      json["access_token"]
      #HTTParty.post('http://www.vikiping.com/oauth/token', query: { grant_type : 'client_credentials', client_id : 'dc363b39f32aebbccbd5c80278e171d1e2a95a2582cef9ddad1c690a2cb4c652', client_secret : '4a1d38d8a1afbc12167e8471e0874c68f893d416f4aee623cb280f18fd0c072e' })
    end


    def configure(client_id, client_secret)
      self.client_id = client_id
      self.client_secret = client_secret
      self.access_token = auth_request(client_id, client_secret)
    end

    # Create a hash of options and their values.
    def options
      VALID_OPTIONS_KEYS.inject({ }) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to default.
    def reset
      self.client_id = DEFAULT_CLIENT_ID
      self.client_secret = DEFAULT_CLIENT_SECRET
      self.access_token = DEFAULT_ACCESS_TOKEN
    end
  end
end
