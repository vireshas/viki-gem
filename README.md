A Viki wrapper gem for the Viki V3 API. This gem is currently under active development.

Full documentation for API V3 may be found at [dev.viki.com](http://dev.viki.com/api "Viki API V3 Docs")


Installation
----------
Manually `gem install viki` or add `gem 'viki'` to Gemfile

Usage
-----
Add where necessary

	require 'viki'

Initialization

	client = Viki.new('your_client_id', 'your_client_secret')

Client is a `Viki::Client` object. When you make a method call, for example `client.movies`, the client will return a `Viki::Request` object - which you will be using to make requests. You may chain methods on the request object. The actual call to the API will only be made when you call `.get` on the request object.

	viki    = client.movies	#returns a Viki::Request object
	results = viki.get		#hits the API and returns a Viki::APIObject

APIObject Methods
-----------------

Responses will be returned in a `Viki::APIObject`. See below

For results that are paginated, you may use the `APIObject`'s `next` and `prev` methods to retrieve the next and previous 25 records respectively.

```
	viki   = client.movies      #returns a Viki::Request
	movies = viki.get			#return records in a Viki::APIObject

	movies.content				#content of the API call in JSON format
	movies.count				#total number of possible results in the endpoint

	movies2 = movies.next		#next 25 records
	movies 	= movies2.prev		#prev 25 records
```


Examples
----------
* Results will always be returned in JSON format.
* This gem simply converts Ruby methods to API endpoints. Each URL namespace is a method. This means that if there is a `/series/` url namespace, the gem's request object will have an equivalent `.series` method. See examples below for an illustration of this behaviour.
* Refer to the [API V3 documentation](http://dev.viki.com/api "Viki API V3 Docs") for complete documentation for all Viki API endpoints.
* All URL endpoints in the following examples should include an `access_token` parameter.

### List Movies
URL

	without parameter filters
	http://www.viki.com/api/v3/movies.json

	with parameter filters
	http://www.viki.com/api/v3/movies.json?genre=2

Your ruby application

	client.movies.get				#without parameter filters
	client.movies(genre: 2).get 	#with parameter filters

### Show Movie
URL

	http://www.viki.com/api/v3/movies/71459.json

Your ruby application

	client.movies(71459).get

### Subtitles
URL

	http://www.viki.com/api/v3/movies/71459/subtitles/en.json

Your ruby application

	client.movies(71459).subtitles('en').get

### Show Episode
URL

	http://www.viki.com/api/v3/series/6004/episodes/61168.json

Your ruby application

	client.series(6004).episodes(61168).get

### List Newscasts

URL

	without parameter filters
	http://www.viki.com/api/v3/newscasts.json

	with parameter filters
	http://www.viki.com/api/v3/newscasts.json?language=ko

Your ruby application

	client.newscasts.get					#without parameter filter
	client.newscasts(language: 'ko').get	#with parameter filter

RSpec Testing
-------------
To run the tests, create a spec_config.rb file from the sample file.

Add your client id and client secret into this file.
