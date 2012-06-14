require 'viki/version'
require 'viki/client'
require 'viki/error'

# Adapted from the Ruby Twitter gem.
# @see https://github.com/jnunemaker/twitter
module Viki

  # Alias for viki::Client.new
  #
  # @return {viki::Client})
  def self.new(client_id, client_secret)
    Viki::Client.new(client_id, client_secret)
  end

end
