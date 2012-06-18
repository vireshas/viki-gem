A Viki wrapper gem for the Viki V3 API. This gem is currently under active development.

Full documentation for API V3 may be found at [dev.viki.com](http://dev.viki.com/api "Viki API V3 Docs")

Endpoints
----------

Here are a full list of functions available.

```
client.movies
client.movie(id)
  client.movie_subtitles(id, lang)
  client.movie_hardsubs(id)

client.series
client.series(:id)
  client.series_episodes(id)
  client.series_episode(id, :series => id)
  client.series_episode_subtitle(id, :series => series_id, :lang => lang_code)
  client.series_episode_hardsubs(id, :series_id)

client.music_videos
client.music_video(id)
  client.music_video_subtitles(id, 'en')
  client.music_video_hardsubs(id)

client.newscasts
client.newscast(id)
  client.newscast_subtitles(id, lang)
  client.newscast_hardsubs(id, lang)
  client.newscast_newsclips(id)

client.newsclips
client.newsclip(id)

client.artists
client.artist(id)
  client.artist_music_videos(id)

client.featured({})

client.coming_soon
client.coming_soon_movies
client.coming_soon_series
```
