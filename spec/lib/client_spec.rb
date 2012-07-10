require 'spec_helper'

describe Viki::Client do

  describe "method delegation" do
    before { Viki::Client.any_instance.stub(:auth_request) }

    def client
      Viki::Client.new('chickenrice', 'soronerychickenrice')
    end

    it "should raise NoMethodError error if part of the call chain is not part of the URL_NAMESPACES list" do
      expect { client.methodwrong.subtitles('en') }.to raise_error(NoMethodError)
    end

    it "should return a request object when method_missing is called" do
      client.movies(1234).should be_an_instance_of(Viki::Request)
    end
  end
end
