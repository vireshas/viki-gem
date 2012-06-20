require 'httparty'
require 'viki/api_object'
require 'viki/request'
require 'multi_json'

module Viki
  class Client
    Dir[File.expand_path('../client/*.rb', __FILE__)].each { |f| require f }

    def initialize(client_id, client_secret)
      @client_id = client_id
      @client_secret = client_secret
      @access_token = auth_request(client_id, client_secret)
      Blesser.set(self.access_token)
    end

    attr_reader :access_token

    include Viki::Request

    def get
      result = request(@call_chain)
      @call_chain = []
      if result.count > 1
        result.extend(Blesser)
        else
          result
      end
    end

    private
    def method_missing(name, *args, &block)
      @call_chain ||= []
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

    module Blesser
      @@access_token

      def self.set(a)
        @@access_token = a
      end

      def direct_request(url)
        response = HTTParty.get(url, query: { access_token: @@access_token })
        capture response
        APIObject.new(response.body)
      end
    end

  end
end
