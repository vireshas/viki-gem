
client.movies
client.movie(:id)
  client.movie.subtitles({id => 5, subtitle => en})
  client.movie(:id).hardsubs

client.series
client.series(:id)
  client.series_episodes(series => id)
  client.series_episode(id, series => id)
  client.series_episode_subtitle(:episode_id, :series_id, :lang_code)
  client.series_episode_hardsubs(:episode_id, :series_id)

client.music_videos
client.music_video(:id)
  client.music_video_subtitles(id, 'en')
  client.music_video_hardsubs(id)

client.newscasts
client.newscast(:id)
  client.newscast_subtitles(:id, :lang)
  client.newscast_hardsubs(:id, :lang)
  client.newscast_newsclips(newscast => :id)

client.newsclips
client.newsclip(:id)

client.artists
client.artist(:id)
  client.artist_music_videos(artist => :id)

client.featured

# UGLLLLYYYYY
client.coming_soon
client.coming_soon_movies
client.coming_soon_series

