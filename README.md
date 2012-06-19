A Viki wrapper gem for the Viki V3 API. This gem is currently under active development.

Full documentation for API V3 may be found at [dev.viki.com](http://dev.viki.com/api "Viki API V3 Docs")

Endpoints
----------

Here are a full list of functions available.

```
client.movies(params)
client.movies(id, params)
  client.movie(id).subtitles(lang)
  client.movie(id).hardsubs

client.movies
client.movies({genre => 2})
client.movies(23)
client.movies(23, params => {language => 'ko'})
client.movies.(23).subtitles('en')
client.movies(23).hardsub

client.series(params)
client.series(id, params)
  client.series_episodes(id, params)
  client.series_episode(id, :series => id) *
  client.series_episode_subtitle(id, :series => series_id, :lang => lang_code) *
  client.series_episode_hardsubs(id, :series_id) *

client.music_videos(params)
client.music_video(id, params)
  client.music_video_subtitles(id, lang)
  client.music_video_hardsubs(id) * implementation waiting on valid examples

client.newscasts(params)
client.newscast(id, params)
client.newscast_newsclips(id)


client.newsclips
client.newsclip(id)
  client.newsclip_subtitles(id, lang)
  client.newsclip_hardsubs(id, lang)


client.artists(params)
client.artist(id, params)
  client.artist_music_videos(id, params)

client.featured(params)

// type processing shouldn't be necessary
// fix in API level
client.coming_soon
client.coming_soon_movies
client.coming_soon_series
```

Optional parameters largely untested!
