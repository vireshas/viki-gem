module Viki
  class Error < StandardError
    attr_accessor :status, :message

    def initialize(status, msg=nil)
      self.status = status
      self.message = msg
      super(msg||"#{self.status}: #{self.message}")
    end
  end
end
