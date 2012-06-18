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
      let(:results) { client.movies(query_options) }
      let(:type) { :movie }

      describe "/movies" do
        it "should return a list Viki::Movie objects" do
          VCR.use_cassette "movies/list" do
            results.each do |movie|
              movie.should be_instance_of(Viki::Movie)
            end
          end
        end

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "movie/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
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

      describe "/movies/:id/subtitles/:lang" do
        it "should return a subtitle JSON string" do
          VCR.use_cassette "movies/subtitles" do
            subtitles = client.movie_subtitles(21713, 'en')
            subtitles["language_code"].should == "en"
            subtitles["subtitles"].should_not be_empty
          end
        end
      end

      describe "movies/:id/hardsubs" do
        it "should return a list of video qualities with links to hardsubbed videos" do
          VCR.use_cassette "movies/hardsubs" do
            hardsubs = client.movie_hardsubs(832)
            hardsubs["res-240p"].should_not be_empty
            hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/832/1/832_en_240p.mp4'
          end
        end
      end
    end

    describe "Series" do

      describe "/series" do
        let(:results) { client.series(query_options) }
        let(:type) { :series }

        it "should return a list of Viki::Series objects" do
          VCR.use_cassette "series/list" do
            results.each do |series|
              series.should be_instance_of(Viki::Series)
            end
          end
        end


        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "series/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
          end
        end

        it_behaves_like "API with parameter filters"
      end

      describe "/series/id" do

        it "should return a Viki::Series object" do
          VCR.use_cassette "series/show" do
            series = client.series(8719)

            series.id.should == 8719
            series.title.should == "I love Lee Tae Ri"
            series.description.should_not be_empty
            series.created_at.should_not be_empty
            series.uri.should_not be_empty
            series.origin_country.should_not be_empty
            series.image.should_not be_empty
            series.episodes.should_not be_empty
            series.subtitles.should_not be_empty
            series.genres.should be_empty # empty for this item
          end
        end

        it "should return a Viki::Series object with description in German if given language option de" do
          VCR.use_cassette "series/language_option" do
            series = client.series(50, { :language => 'de' })
            series.description.should == 'Die koreanische Verfilmung des Manga "Hana Yori Dango" .'
          end
        end
      end

      describe "series/:id/episodes" do
        it "returns a list of Viki::Episode objects for a particular series" do
          VCR.use_cassette "series/episodes" do
            episodes = client.series_episodes(50)
            episodes.each do |e|
              e.should be_instance_of(Viki::Episode)
            end
          end
        end
      end

    end

    describe "Newscasts" do

      describe "/newscasts" do
        let(:results) { client.newscasts(query_options) }
        let(:type) { :newscast }

        it "should return a list of Viki::Newscast objects" do
          VCR.use_cassette "newscasts/list" do
            results.each do |newscast|
              newscast.should be_instance_of(Viki::Newscast)
            end
          end
        end

        it_behaves_like "API with parameter filters"
      end

      describe "/newscasts/id" do

        it "should return a Viki::Newscast object" do
          VCR.use_cassette "newscast/show", :record => :new_episodes do
            newscast = client.newscast(1659)

            newscast.id.should == 1659
            newscast.title.should == "Entertainment News - Korea "
            newscast.description.should_not be_empty
            newscast.uri.should_not be_empty
            newscast.image.should_not be_empty
          end
        end
      end
    end
  end
end
