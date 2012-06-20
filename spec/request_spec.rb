# encoding: utf-8

require 'spec_helper'
require 'filter_shared_examples_spec'

describe "Viki" do
  let(:client_id) { '4bd5edd4ba26ac2f3ad9d204dc6359ea8a3ebe2c95b6bc1a9195c0ce5c57d392' }
  let(:client_secret) { 'f3b796a1eb6e06458a502a89171a494a9160775ed4f4e9e0008c638f7e7e7d38' }

  describe "Auth" do
    it "should retrieve an access token when the Viki object is configured and initialized" do
      VCR.use_cassette "auth" do
        client = Viki.new(client_id, client_secret)
        client.access_token.should == '1b080a6b3a94ed4503e04e252500ca87f6e7dc55061cec92b627ef1fbec44c70'
      end
    end

    it "should return an error when the client_secret or client_id is incorrect" do
      VCR.use_cassette "auth_error" do
        lambda { Viki.new('12345', '54321') }.should raise_error(Viki::Error,
                                                                 "Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.")
      end
    end
  end

  describe "API Interactions" do
    let(:query_options) { { } }
    let(:client) do
      VCR.use_cassette "auth" do
        Viki.new(client_id, client_secret)
      end
    end

    describe "Movies" do
      let(:results) { client.movies(query_options).get }
      let(:type) { :movie }

      describe "/movies" do
        it "should return a list Viki::Movie objects" do
          VCR.use_cassette "movies/list", :record => :new_episodes do
            results.content.each do |movie|
              movie.should be_instance_of(Hash)
            end
          end
        end

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "movie/platform_filter_error", :record => :new_episodes do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
          end
        end

        #it_behaves_like "API with parameter filters"
      end

      describe "/movies/:id" do
        it "should return a Viki::Movie object" do
          VCR.use_cassette "movie_show", :record => :new_episodes do
            response = client.movies(70436).get
            movie = response.content
            puts "===> response: #{(response).inspect}"
            puts "===> response.content: #{(response.content).inspect}"

            #overtesting
            movie["id"].should == 70436
            movie["title"].should == "Muoi: The Legend of a Portrait"
            movie["description"].should_not be_empty
            movie["created_at"].should_not be_empty
            movie["uri"].should_not be_empty
            movie["origin_country"].should_not be_empty
            movie["image"].should_not be_empty
            movie["formats"].should_not be_empty
            movie["subtitles"].should be_empty #is actually empty in this call
            movie["genres"].should_not be_empty
          end
        end

        it "should return a Viki::Error object when resource not found" do
          VCR.use_cassette "movie_error", :record => :new_episodes do
            lambda { client.movies(50).get }.should raise_error(Viki::Error, "The resource couldn't be found")
          end
        end
      end

      describe "/movies/:id/subtitles/:lang" do
        it "should return a subtitle JSON string" do
          VCR.use_cassette "movies/subtitles", :record => :new_episodes do
            response = client.movies(21713).subtitles('en').get
            subtitles = response.content
            subtitles["language_code"].should == "en"
            subtitles["subtitles"].should_not be_empty
          end
        end
      end

      describe "movies/:id/hardsubs" do
        it "should return a list of video qualities with links to hardsubbed videos" do
          VCR.use_cassette "movies/hardsubs", :record => :new_episodes do
            response = client.movies(64135).hardsubs.get
            hardsubs = response.content
            hardsubs["res-240p"].should_not be_empty
            hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/64135/1/64135_en_240p.mp4'
          end
        end
      end
    end

  end
end
