module Viki
  class Request
    def initialize(auth_data, name, *args)
      @access_token = auth_data[:access_token]
      @client_id = auth_data[:client_id]
      @client_secret = auth_data[:client_secret]

      build_call_chain(name, *args)
    end

    attr_reader :access_token

    include Viki::Transport

    def get
      current_chain = @call_chain
      request(current_chain)
    end

    def reset_access_token
      @access_token = auth_request(@client_id, @client_secret)
    end

    def url
      path, params = build_url(@call_chain)
      params.delete(:access_token)

      url_params = ""
      params.keys.each { |key| url_params += "#{key}=#{params[key]}&" }

      "#{path.chop}?#{url_params.chop}"
    end

    private
    def method_missing(name, *args)
      build_call_chain(name, *args)
      self
    end

    def build_call_chain(name, *args)
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
    end

  end
end

