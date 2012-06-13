module Viki
  # Custom error class for rescuing from all known Pixmatch errors.
  class Error < StandardError
    attr_accessor :status, :message

    def initialize(json)
      @status = json['status']
      @message = json['message']
      #TODO = return method?
    end

    def to_s
      s = @message.nil? ? 'Unexpected Error' : @message.join('\r\n')
      s += ("\r\n " + message.join('\r\n ')) if message
    end
  end
end
