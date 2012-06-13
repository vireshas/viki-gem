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
