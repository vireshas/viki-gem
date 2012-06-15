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
    let(:client) do
      VCR.use_cassette "auth" do
        Viki.new(client_id, client_secret)
      end
    end

    describe "Movies" do

      let(:query_options) { { } }
      let(:results) { client.movies(query_options) }
      let(:type) { :movie }

      describe "/movies" do
        it "should return a list Viki::Movie objects" do
          VCR.use_cassette "movies_list" do
            results.each do |movie|
              movie.should be_instance_of(Viki::Movie)
            end
          end
        end

        it_behaves_like "API with parameter filters"
      end

      describe "/movies/:id" do
        it "should return a Viki::Movie object" do
          VCR.use_cassette "movie_show" do
            movie = client.movie(70436)

            #overtesting
            movie.id.should == 70436
            movie.title.should == "Muoi: The Legend of a Portrait"
            movie.description.should_not be_empty
            movie.created_at.should_not be_empty
            movie.uri.should_not be_empty
            movie.origin_country.should_not be_empty
            movie.image.should_not be_empty
            movie.formats.should_not be_empty
            movie.subtitles.should be_empty #is actually empty in this call
            movie.genres.should_not be_empty
          end
        end

        it "should return a Viki::Error object when resource not found" do
          VCR.use_cassette "movie_error" do
            lambda { client.movie(50) }.should raise_error(Viki::Error, "The resource couldn't be found")
          end
        end
      end
    end
  end
end
