require File.expand_path('../viki/version', __FILE__)
require File.expand_path('../viki/configuration', __FILE__)
require File.expand_path('../viki/utils', __FILE__)

# Adapted from the Ruby Twitter gem.
# @see https://github.com/jnunemaker/twitter
module Viki
  extend Configuration

  # Alias for viki::Client.new
  #
  # @return {viki::Client}
  def self.client(options = { })
    viki::Client.new(options)
  end

  # Delegate to viki::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to viki::Client
  def self.respond_to?(method)
    return client.respond_to?(method) || super
  end
end
