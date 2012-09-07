require 'spec_helper'

describe Viki::Client do
  before { Viki::Client.any_instance.stub(:auth_request) }

  def client(domain = nil)
    domain ? Viki::Client.new('foo', 'bar', host=domain) : Viki::Client.new('foo', 'bar')
  end

  describe "method delegation" do
    it "should raise NoMethodError error if part of the call chain is not part of the URL_NAMESPACES list" do
      expect { client.methodwrong.subtitles('en') }.to raise_error(NoMethodError)
    end

    it "should return a request object when method_missing is called" do
      client.movies(1234).should be_an_instance_of(Viki::Request)
    end
  end

  describe "API host toggling" do
    it "should set host to http://www.viki.com when no domain parameter is set" do
      client.instance_variable_get(:@host).should == 'http://www.viki.com'
    end

    it "should set host to custom host if domain parameter is set" do
      client(host = "http://test.com").instance_variable_get(:@host).should == 'http://test.com'
    end
  end
end
