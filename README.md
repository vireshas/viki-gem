A Viki wrapper gem for the Viki V3 API. This gem is currently under active development.

Full documentation for API V3 may be found at [dev.viki.com](http://dev.viki.com/api "Viki API V3 Docs")


Installation
----------
Manually `gem install viki` or add `gem 'viki'` to Gemfile

How to use
----------
Add to your .rb

	require 'viki'

Initialization

	viki = Viki.new('your_client_id', 'your_client_secret')


Responses will be returned in a `Viki::APIObject`.

For results that are paginated. You can use the `APIObject`'s `next` and `prev` methods to retrieve the next and previous 25 records respectively.

```
	viki.movies
	movies = viki.get			#return records in a Viki::APIObject

	movies.content				#content of the API call in JSON format
	movies.count				#total number of possible results in the endpoint

	movies2 = movies.next		#next 25 records
	movies 	= movies2.prev		#prev 25 records
```


Examples
----------
* Results will always be returned in JSON format.
* All URL endpoints in the following examples should include an `access_token` parameter.
* Refer to the [API V3 documentation](http://dev.viki.com/api "Viki API V3 Docs") for all endpoints.

### List Movies
URL

	without parameter filters
	http://www.viki.com/api/v3/movies.json

	with parameter filters
	http://www.viki.com/api/v3/movies.json?genre=2

Your ruby application

	viki.movies.get				#without parameter filters
	viki.movies(genre: 2).get 	#with parameter filters

### Show Movie
URL

	http://www.viki.com/api/v3/movies/71459.json

Your ruby application

	viki.movies(71459).get

### Subtitles
URL

	http://www.viki.com/api/v3/movies/71459/subtitles/en.json

Your ruby application

	viki.movies(71459).subtitles('en').get

### Show Episode
URL

	http://www.viki.com/api/v3/series/6004/episodes/61168.json

Your ruby application

	viki.series(6004).episodes(61168).get

### List Newscasts

URL

	without parameter filters
	http://www.viki.com/api/v3/newscasts.json

	with parameter filters
	http://www.viki.com/api/v3/newscasts.json?language=ko

Your ruby application

	viki.newscasts.get					#without parameter filter
	viki.newscasts(language: 'ko').get	#with parameter filter

