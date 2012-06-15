require 'spec_helper'

shared_examples_for "API with parameter filters" do
  context "when filtering with genre" do
    let(:query_options) { { :genre => 2 } }
    it "should return a genre-filtered list of Viki::Movie objects when given genre params" do
      VCR.use_cassette "#{type}/genre_filter" do
        results.each do |m|
          m.genres.each do |g|
            g["id"].should == 2
          end
        end
      end
    end
  end

  context "when filtering with subtitle_language" do
    let(:query_options) { { :subtitle_language => 'fr' } }
    it "should return movies with requested subtitle > 90% completion, when given a subtitle_language parameter" do
      VCR.use_cassette "#{type}/subtitle_language_filter" do
        results.each do |m|
          m.subtitles["fr"].should > 90
        end
      end
    end
  end

  context "when filtering with watchable_in" do
    let(:query_options) { { :watchable_in => 'sg' } }
    it "should return movies watchable_in selected country when given a watchable_in parameter" do
      VCR.use_cassette "#{type}/watchable_in_filter" do
        results.should_not be_empty
      end
    end
  end

  context "when filtering with origin_country" do
    let(:query_options) { { :origin_country => 'kr' } }
    it "should return movies from a specific country when given a origin_country parameter" do
      VCR.use_cassette "#{type}/origin_country_filter" do
        results.each do |m|
          m.origin_country.should == 'Korea'
        end
      end
    end
  end


  context "when filtering with platform" do
    let(:query_options) { { :platform => 'mobile' } }
    it "should return movies available in selected platform when given watchable_in and platform parameters" do
      query_options.merge!({ :watchable_in => 'sg' })
      VCR.use_cassette "#{type}/platform_filter" do
        results.should_not be_empty
      end
    end


    it "should raise an error when platform parameter is given without watchable_in" do
      VCR.use_cassette "#{type}/platform_filter_error" do
        lambda { results }.should raise_error(Viki::Error)
      end
    end
  end
end


