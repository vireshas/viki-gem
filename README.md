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

client.series(params)
client.series(id, params)
  client.series(id).episodes(params)
  client.series(id).episodes(id)
  client.series(id).episodes(id).subtitles(lang)
  client.series(id).episodes(id).hardsubs

client.music_videos(params)
client.music_video(id, params)
  client.music_video(id).subtitles(lang)
  client.music_video(id).hardsubs * implementation waiting on valid examples

client.newscasts(params)
client.newscasts(id, params)
client.newscasts(id).newsclips


client.newsclips
client.newsclips(id)
  client.newsclips(id).subtitles(lang)
  client.newsclips(id).hardsubs(lang)


client.artists(params)
client.artist(id, params)
  client.artists(id).music_videos(params)

client.featured(params)

client.coming_soon
client.coming_soon.movies
client.coming_soon.series
```

