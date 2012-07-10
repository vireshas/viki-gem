require 'spec_helper'

describe Viki::Request do
  describe "#get" do
    before do
      Viki::Client.any_instance.stub(:auth_request)
      Viki::Request.any_instance.stub(:request) { Viki::APIObject }
    end

    def client
      Viki.new('chickenrice', 'soronerychickenrice')
    end

    it "should perform a request to the right url given a call chain" do
      req = client.movies(1234).subtitles('en')
      req.should_receive(:request).with([{ :name => :movies, :resource => 1234 },
                                             { :name => :subtitles, :resource => "en" }])
      req.get
    end

    it "should perform a request with the right params given a call chain" do
      req = client.movies(1234, { genre: 2 })
      req.should_receive(:request).with([{ :name => :movies, :resource => 1234, :params => { genre: 2 } }])
      req.get
    end

    it "should raise NoMethodError error if part of the call chain is not part of the URL_NAMESPACES list" do
      expect { client.methodwrong.subtitles('en') }.to raise_error(NoMethodError)
    end
  end
end
