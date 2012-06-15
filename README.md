
client.list_movies
client.movie(:id)
  client.movie(:id).subtitles('en')
  client.movie(:id).hardsubs

client.list_series
client.series(:id)
  client.series(:id).subtitles('en')
  client.series(:id).hardsubs
  client.series(:id).list_episodes
  client.series(:id).episode(:id)

client.list_music_videos
client.music_video(:id)
  client.music_videos(:id).subtitles('en')
  client.music_videos(:id).hardsubs

client.list_newscasts
client.newscast(:id)
  client.newscast(:id).subtitles('en')
  client.newscast(:id).hardsubs
  client.newscast(:id).newsclips

client.list_newsclips
client.newsclip(:id)

client.list_artists
client.artist(:id)
  client.artist(:id).list_music_videos

client.list_featured

# UGLLLLYYYYY
client.list_coming_soon
client.coming_soon.list_movies
client.coming_soon.list_series
