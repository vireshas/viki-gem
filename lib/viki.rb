require 'viki/version'
require 'viki/client'
require 'viki/error'
require 'viki/utilities'

# Adapted from the Grackle Twitter gem.
module Viki

  # Alias for viki::Client.new
  #
  # @return {viki::Client})
  def self.new(client_id, client_secret)
    Viki::Client.new(client_id, client_secret)
  end

end
