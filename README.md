A Viki wrapper gem for the Viki V3 API. This gem is currently under active development.

Full documentation for API V3 may be found at [dev.viki.com](http://dev.viki.com/api "Viki API V3 Docs")


Installation
----------
Manually: `gem install viki` or add `gem 'viki'` to Gemfile

How to use
----------
Add following to your .rb

	`require 'viki'`

Initialization

	`viki = Viki.new('your_client_id', 'your_client_secret')`


Responses will be returned in a `Viki::ApiObject`.

For results that are paginated. You can use the `ApiObject`'s `next` and `prev` methods to retrieve the next and prev 25 records respectively.

```
	movies 	= viki.movies.get	#returns 25 records in a Viki::APIObject

	movies.content				#returns you the content of the query
	movies.count				#total number possible results in the endpoint

	movies2 = movies.next		#next 25 records
	movies 	= movies2.prev		#prev 25 records
```


Examples
----------
* This gem is designed to work closely with Viki V3 API.
* Results will always be returned in XML format.
* All URL endpoints in the following examples should include an `access_token` parameter.

#### List Movies
URL

	without parameter filters
	http://www.viki.com/api/v3/movies.json

	with parameter filters
	http://www.viki.com/api/v3/movies.json?genre=2

Your ruby application

	viki.movies.get				#without parameter filters
	viki.movies.get(genre: 2)	#with parameter filters

#### Show Movie
URL

	http://www.viki.com/api/v3/movies/50.json

Your ruby application

	viki.movies(50)

#### Subtitles
URL

	http://www.viki.com/api/v3/movies/64488/subtitles/en.json

Your ruby application

	viki.movies(64488).subtitles('en')

#### Show Episode
URL

	http://www.viki.com/api/v3/series/6004/episodes/61168.json

Your ruby application

	viki.series(6004).episodes(61568)

#### List Newscasts

URL

	without parameter filters
	http://www.viki.com/api/v3//api/v3/newscasts.json

	with parameter filters
	http://www.viki.com/api/v3//api/v3/newscasts.json?language=ko

Your ruby application

	viki.newscasts					#without parameter filter
	viki.newcasts(language: 'ko')	#with parameter filter

Refer to the [API V3 documentation](http://dev.viki.com/api "Viki API V3 Docs") for all endpoints.

