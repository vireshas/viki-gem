require 'spec_helper'

describe "Viki" do
  let(:client_id) { CLIENT_ID }
  let(:client_secret) { CLIENT_SECRET }

  describe "Auth" do
    it "should retrieve an access token when the Viki object is configured and initialized" do
      VCR.use_cassette "auth" do
        client = Viki.new(client_id, client_secret)
        client.access_token.should_not be_nil
      end
    end

    it "should return an error when the client_secret or client_id is incorrect" do
      VCR.use_cassette "auth_error" do
        lambda { Viki.new('12345', '54321') }.should raise_error(Viki::Error,
                                                                 'Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method.')
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
          VCR.use_cassette "movies/list" do
            results.content.each do |movie|
              movie.should be_instance_of(Hash)
            end
          end
        end

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "movie/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error,
                                                  "Require watchable_in parameter when given platform parameter")
          end
        end
      end

      describe "/movies/:id" do
        it "should return a Viki::Movie object" do
          VCR.use_cassette "movie_show" do
            response = client.movies(70436).get
            movie = response.content

            #overtesting
            movie["id"].should == 70436
            movie["title"].should == "Muoi: The Legend of a Portrait"
            movie["description"].should_not be_empty
            movie["created_at"].should_not be_empty
            movie["uri"].should_not be_empty
            movie["origin_country"].should_not be_empty
            movie["image"].should_not be_empty
            movie["formats"].should_not be_empty
            movie["subtitles"].should_not be_empty
            movie["genres"].should_not be_empty
          end
        end

        it "should return a Viki::Error object when resource not found" do
          VCR.use_cassette "movie_error" do
            lambda { client.movies(50).get }.should raise_error(Viki::Error, "The resource couldn't be found")
          end
        end
      end

      describe "/movies/:id/subtitles/:lang" do
        it "should return a subtitle JSON string" do
          VCR.use_cassette "movies/subtitles" do
            response = client.movies(21713).subtitles('en').get
            response.count.should == 1
            subtitles = response.content
            subtitles["language_code"].should == "en"
            subtitles["subtitles"].should_not be_empty
          end
        end
      end

      describe "movies/:id/hardsubs" do
        it "should return a list of video qualities with links to hardsubbed videos" do
          VCR.use_cassette "movies/hardsubs" do
            response = client.movies(64135).hardsubs.get
            response.count.should == 1
            hardsubs = response.content
            hardsubs["res-240p"].should_not be_empty
          end
        end
      end

      describe "APIObject pagination" do
        it "returns an APIObject for APIObject containing movies when it has a next page" do
          VCR.use_cassette "APIObject/pagination" do
            response = client.movies.get
            result = response.next
            result.count.should > 1
            result.content.should_not be_empty
            result.should be_instance_of(Viki::APIObject)
          end
        end

        it "returns nil if there is movies listing has no next page" do
          VCR.use_cassette "APIObject/pagination_fail" do
            response = client.movies({ page: 6 }).get
            result = response.next
            result.should be_nil
          end
        end
      end
    end

    describe "Renew Expired Access Token" do
      it "should request a new access token when an endpoint returns 401 and client currently has an access_token" do
        VCR.use_cassette "auth/expired_access_token" do
          client.access_token.should_not be_empty
          client.instance_variable_set(:@access_token, "rubbishaccesstoken")
          response = client.movies.get
          response.content.should_not be_empty
        end
      end
    end

    describe ".next" do
      it "should invoke direct_request with a next_url" do
        VCR.use_cassette("movies/list/pg2", :record => :new_episodes) do
          movies = client.movies.get
          next_url = movies.instance_variable_get(:@next_url)
          movies.should_receive(:direct_request).with(next_url)
          movies.next
        end
      end
    end

    describe ".prev" do
      it "should invoke direct_request with previous_url" do
        VCR.use_cassette("movies/list/pg2", :record => :new_episodes) do
          movies_pg1 = client.movies.get
          movies_pg2 = movies_pg1.next
          previous_url = movies_pg2.instance_variable_get(:@previous_url)
          movies_pg2.should_receive(:direct_request).with(previous_url)
          movies_pg2.prev
        end
      end
    end

    describe "Errors" do
      it "should raise NoMethodError if a method that is not on the whitelist is called" do
        expect { client.does_not_exist }.should raise_error(NoMethodError)
      end

      it "should use the proper call chain after a failed request" do
        VCR.use_cassette "movie_error" do
          lambda { client.movies(50).get }.should raise_error(Viki::Error, "The resource couldn't be found")
        end

      results = client.movies.get
      results.should be_instance_of(Viki::APIObject)
      end
    end
  end
end
