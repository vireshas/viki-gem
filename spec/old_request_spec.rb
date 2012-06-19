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
      let(:results) { client.movies(query_options) }
      let(:type) { :movie }

      describe "/movies" do
        it "should return a list Viki::Movie objects" do
          VCR.use_cassette "movies/list" do
            results.each do |movie|
              movie.should be_instance_of(Viki::APIObject)
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
            hardsubs = client.movie_hardsubs(64135)
            hardsubs["res-240p"].should_not be_empty
            hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/64135/1/64135_en_240p.mp4'
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
              series.should be_instance_of(Viki::APIObject)
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
              e.should be_instance_of(Viki::APIObject)
            end
          end
        end
      end

      describe "/series/:id/episodes/:id" do
        it "returns a Viki::Episode object for a particular episode when given both series and episode id" do
          VCR.use_cassette "series/episode+id" do
            episode = client.series_episode(509, :series => 50)

            episode.id.should == 509
            episode.title.should == "Episode 1"
            episode.number.should == 1
            episode.description.should be_nil
            episode.image.should_not be_empty
            episode.created_at.should_not be_empty
            episode.series.should_not be_empty
            episode.uri.should_not be_empty
            episode.series.should_not be_empty
            episode.formats.should_not be_empty
            episode.language_code.should_not be_empty
          end
        end
      end

      describe "series/:id/episodes/:id/subtitles" do
        it "returns the subtitles for an episode under a series channel" do
          VCR.use_cassette "series/episode+subtitles" do
            subtitles = client.series_episode_subtitles(509, :series => 50, :lang => 'en')
            subtitles["language_code"].should == "en"
            subtitles["subtitles"].should_not be_empty
          end
        end
      end

      describe "series/:id/episodes/:id/hardsubs" do
        it "returns the hardsubs for an episode under a series channel" do
          VCR.use_cassette "series/episode+hardsubs" do
            hardsubs = client.series_episode_hardsubs(852, :series => 72)
            hardsubs["res-240p"].should_not be_empty
            hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/852/1/852_en_240p.mp4'
          end
        end
      end
    end

    describe "Newscasts" do

      describe "/newscasts" do
        let(:results) { client.newscasts(query_options) }
        let(:type) { :newscast }

        it "should return a list of Viki::Newscast objects" do
          VCR.use_cassette "newscast/list" do
            results.each do |newscast|
              newscast.should be_instance_of(Viki::APIObject)
            end
          end
        end
      end

      describe "/newscasts/id" do

        it "returns a Viki::Newscast object" do
          VCR.use_cassette "newscast/show" do
            newscast = client.newscast(1659)

            newscast.id.should == 1659
            newscast.title.should == "Entertainment News - Korea "
            newscast.description.should_not be_empty
            newscast.uri.should_not be_empty
            newscast.image.should_not be_empty
            newscast.newsclips.should_not be_empty
          end
        end
      end

      describe "/newscasts/id/newsclips" do

        it "returns a list of Viki::Newsclips for the specified Newscast" do
          VCR.use_cassette "newscast/list_newsclip" do

            newscasts = client.newscast_newsclips(1659)

            newscasts.length.should == 25
            newscasts.each do |n|
              n.should be_instance_of(Viki::APIObject)
            end
          end
        end
      end
    end

    describe "Newsclips" do

      describe "/newsclips" do
        let(:results) { client.newsclips(query_options) }
        let(:type) { :newsclip }

        it "should return a list of Viki::Newscast objects" do
          VCR.use_cassette "newsclips/list" do
            results.each do |newsclip|
              newsclip.should be_instance_of(Viki::APIObject)
            end
          end
        end
      end

      describe "/newsclips/id" do

        it "should return a Viki::Newsclip object" do
          VCR.use_cassette "newsclip/show", :record => :new_episodes do
            newsclip = client.newsclip(62542)

            newsclip.id.should == 62542
            newsclip.title.should == "Lindsay Lohan to Host SNL"
            newsclip.description.should_not be_empty
            newsclip.uri.should_not be_empty
            newsclip.image.should_not be_empty
            newsclip.newscast.should_not be_empty
          end
        end
      end

      describe "/newsclips/:id/subtitles/:lang" do
        it "should return a subtitle JSON string" do
          VCR.use_cassette "newsclip/subtitles" do

            subtitles = client.newsclip_subtitles(64488, 'en')
            subtitles["language_code"].should == "en"
            subtitles["subtitles"].should_not be_empty
          end
        end
      end

      describe "/news_clip/:id/hardsubs" do
        it "should return a list of video qualities with links to hardsubbed videos" do
          VCR.use_cassette "newsclip/hardsubs" do
            hardsubs = client.newsclip_hardsubs(70988)
            hardsubs["res-240p"].should_not be_empty
            hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/70988/1/70988_en_240p.mp4'
          end
        end
      end
    end

    describe "MusicVideos" do


      describe "/music_videos" do
        let(:results) { client.music_videos(query_options) }
        let(:type) { :music_video }

        it "should return a list of Viki::MusicVideo objects" do
          VCR.use_cassette "music_videos/list" do
            results.each do |music_video|
              music_video.should be_instance_of(Viki::APIObject)
            end
          end
        end

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "music_videos/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
          end
        end

        it_behaves_like "API with parameter filters"
      end

      describe "/music_videos/id" do

        it "should return a Viki::MusicVideo object" do
          VCR.use_cassette "music_video/show", :record => :new_episodes do
            music_video = client.music_video(71584)

            music_video.id.should == 71584
            music_video.title.should == "I Feel Like I'm Dying"
            music_video.uri.should_not be_empty
            music_video.image.should_not be_empty
          end
        end
      end
    end

    describe "/music_video/:id/subtitles/:lang" do
      it "should return a subtitle JSON string" do
        VCR.use_cassette "music_videos/subtitles" do
          subtitles = client.music_video_subtitles(538, 'en')
          subtitles["language_code"].should == "en"
          subtitles["subtitles"].should_not be_empty
        end
      end
    end

    #none available yet
    #describe "/music_video/:id/hardsubs" do
    #  it "should return a list of video qualities with links to hardsubbed videos" do
    #    VCR.use_cassette "music_video/hardsubs" do
    #      hardsubs = client.music_video_hardsubs(64135)
    #      hardsubs["res-240p"].should_not be_empty
    #      hardsubs["res-240p"]["en"].should == 'http://video1.viki.com/hardsubs/64135/1/64135_en_240p.mp4'
    #    end
    #  end
    #end

    describe "Artist" do

      describe "/artist" do
        let(:results) { client.artists(query_options) }
        let(:type) { :artist }

        it "should return a list of Viki::Artist objects" do
          VCR.use_cassette "artists/list" do
            results.each do |artist|
              artist.should be_instance_of(Viki::APIObject)
            end
          end
        end

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "artists/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
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
        end

        context "when requesting artist name in different language" do
          it "should return artist name in parameter given" do
            query_options.merge!({ :language => 'ko' })
            VCR.use_cassette "#{type}/language_filter" do
              results.last.name.should == "윤서진"
            end
          end
        end
      end

      describe "/artist/id" do

        it "should return a Viki::Artist object" do
          VCR.use_cassette "artist/show", :record => :new_episodes do
            artist = client.artist(8615)

            artist.id.should == 8615
            artist.name.should == "Michelle Branch"
            artist.uri.should_not be_empty
            artist.image.should_not be_empty
            artist.origin_country.should == "United States"
          end
        end
      end

      describe "/artist/id/music_videos" do

        let(:id) { 834 }
        let(:results) { client.artist_music_videos(id, query_options) }
        let(:type) { :artist_music_videos }

        it "should return a list of Viki::MusicVideo objects" do
          VCR.use_cassette "artist_music_videos/list" do
            results.each do |music_video|
              music_video.should be_instance_of(Viki::APIObject)
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

        it "should raise an error when platform parameter is given without watchable_in" do
          VCR.use_cassette "artist_music_videos/platform_filter_error" do
            query_options.merge!({ :platform => 'mobile' })
            lambda { results }.should raise_error(Viki::Error)
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
        end
      end
    end

    describe "/featured" do
      it "returns a list of Viki::FeaturedItem objects" do
        VCR.use_cassette "featured" do
          features = client.featured
          features.each do |f|
            f.should be_instance_of(Viki::APIObject)
          end
        end
      end

      it "should return a list of Viki::FeaturedItem objects for the given origin_country" do
        VCR.use_cassette "featred/origin_country" do
          features = client.featured({ :origin_country => 'ko' })
          features.each do |f|
            f.origin_country.should == 'ko'
          end
        end
      end

      it "should return a Viki::Error if platform params is not passed with watchable_in" do
        VCR.use_cassette "featured/error" do
          lambda { client.featured({ :platform => 'mobile' }) }.should raise_error(Viki::Error)
        end
      end
    end

    describe "Coming Soon" do

      describe "/coming_soon" do
        it "should return a list of Viki::ComingSoon objects" do
          VCR.use_cassette "coming_soon" do
            results_list = client.coming_soon
            results_list.each do |cm|
              cm.should be_instance_of(Viki::APIObject)
            end
          end
        end

        describe "/coming_soon/movies" do
          it "should return a list of Viki::ComingSoon objects of type 'movie'" do
            VCR.use_cassette "coming_soon/movies" do
              results_list = client.coming_soon_movies
              results_list.each do |cm|
                cm.should be_instance_of(Viki::APIObject)
                cm.type.should == "movie"
              end
            end
          end
        end

        describe "coming_soon/series" do
          it "should return a list of Viki::ComingSoon objects of type 'series'" do
            VCR.use_cassette "coming_soon/series" do
              results_list = client.coming_soon_series
              results_list.each do |cm|
                cm.should be_instance_of(Viki::APIObject)
                cm.type.should == "series"
              end
            end
          end
        end
      end
    end
  end
end
