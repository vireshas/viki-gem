require 'httparty'
require 'viki/api_object'
require 'viki/request'
require 'multi_json'

module Viki
  class Client
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }
    URL_NAMESPACES = [:movies, :series, :episodes, :music_videos, :newscasts, :newsclips,
            :artists, :featured, :coming_soon, :subtitles, :hardsubs]

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
    end

    attr_reader :access_token

    include Viki::Request

    def get
      request(@call_chain)
    end

    def reset_access_token
      @access_token = auth_request(@client_id, @client_secret)
    end

    private
    def method_missing(name, *args, &block)
      @call_chain ||= []
      raise NoMethodError if not URL_NAMESPACES.include? name

      curr_call = { name: name }

      first_arg, second_arg = args[0], args[1]

      if args.length == 1
        first_arg.is_a?(Hash) ? curr_call.merge!({ params: first_arg }) : curr_call.merge!({ resource: first_arg })
      elsif args.length == 2
        curr_call.merge!({ resource: first_arg })
        curr_call.merge!({ params: second_arg })
      end

      @call_chain.push(curr_call)
      self
    end

  end
end
