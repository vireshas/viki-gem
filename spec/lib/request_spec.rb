require 'spec_helper'

describe Viki::Request do
  DEFAULT_HOST = "http://www.viki.com"

  before do
    Viki::Client.any_instance.stub(:auth_request)
  end

  def client
    Viki.new('chickenrice', 'soronerychickenrice')
  end

  describe "#get" do
    it "should perform a request to the right url given a call chain" do
      req = client.movies(1234).subtitles('en')
      req.should_receive(:request).with([{ :name => :movies, :resource => 1234 },
                                             { :name => :subtitles, :resource => "en" }], DEFAULT_HOST)
      req.get
    end

    it "should perform a request with the right params given a call chain" do
      req = client.movies(1234, { genre: 2 })
      req.should_receive(:request).with([{ :name => :movies, :resource => 1234, :params => { genre: 2 } }], DEFAULT_HOST)
      req.get
    end

    it "should not clear the call_chain after .get is called" do
      req = client.movies(1234, { genre: 2 })
      req.should_receive(:request)
      req.get
      req.instance_variable_get(:@call_chain).should_not == []
    end

    it "should raise NoMethodError error if part of the call chain is not part of the URL_NAMESPACES list" do
      expect { client.methodwrong.subtitles('en') }.to raise_error(NoMethodError)
    end
  end

  describe "#url" do
    it "should return the right url for the method call" do
      req = client.movies(1234, { genre: 2, per_page: 3 })
      req.url.should == "movies/1234?genre=2&per_page=3"

      req = client.series(1234)
      req.url.should == "series/1234"
    end
  end
end
