
client.movies.list
client.movie(:id)
  client.movie.subtitles({id => 5, subtitle => en})
  client.movie(:id).hardsubs

client.series.list
client.series(:id)
  client.serie(:id).subtitles('en')
  client.serie(:id).hardsubs
  client.serie(:id).episodes
  client.serie(:id).episode(:id)

client.list_music_videos.list
client.music_video(:id)
  client.music_video(:id).subtitles('en')
  client.music_video(:id).hardsubs

client.newscasts.list
client.newscast(:id)
  client.newscast(:id).subtitles('en')
  client.newscast(:id).hardsubs
  client.newscast(:id).newsclips

client.newsclips.list
client.newsclips(:id)

client.artists.list
client.artist(:id)
  client.artist(:id).music_videos.list

client.featured.list

# UGLLLLYYYYY
client.coming_soon.list
client.coming_soon.list_movies
client.coming_soon.list_series
