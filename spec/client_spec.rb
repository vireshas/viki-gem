require 'spec_helper'

describe Viki::Client do

  describe "#get" do
    before { Viki::Client.any_instance.stub(:auth_request) }
    subject { Viki::Client.new('chickenrice', 'soronerychickenrice') }

    it "should perform a request to the right url given a call chain" do
      subject.movies(1234).subtitles('en')
      subject.should_receive(:request).with([{ :name => :movies, :resource => 1234 },
                                             { :name => :subtitles, :resource => "en" }])
      subject.get
    end

    it "should perform a request with the right params given a call chain" do
      subject.movies(1234, {genre: 2})
      subject.should_receive(:request).with([{ :name => :movies, :resource => 1234, :params => {genre: 2}}])
      subject.get
    end

    it "should raise NoMethodError error if part of the call chain is not part of the URL_NAMESPACES list" do
      expect { subject.methodwrong.subtitles('en') }.to raise_error(NoMethodError)
    end
  end
end
