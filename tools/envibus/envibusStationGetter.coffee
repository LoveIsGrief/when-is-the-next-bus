_ = require "lodash"
ConcatStream = require "concat-stream"
Http = require "http"
Q = require 'q'

# Object to fill
stationLists = {}

# Returns an array of promises to parse each station list
doStationList = ->

	regex = /href="..\/\?ptano=([\d$]+)([\w\s]+)"/g
	# Match the given string with the regex
	# and fills the stationLists
	fillMatches = (aString)->
		match = null
		while ((match = regex.exec(aString)) != null)
			if match.index == regex.lastIndex
				regex.lastIndex++

			stationLists[match[2]] = match[1]


	baseUrl = "http://tempsreel.envibus.fr/list/?com_id=0&letter="
	# creates a URL that we will later parse
	buildStationListUrl = (letter)->
		baseUrl + letter

	# passes an argument as the first argument to Http.get
	parseStationListUrl = (url)->
		deferred = Q.defer()
		Http.get url, (response)->

			concatStream = new ConcatStream { encoding: "string"}

			# Put incoming data straight into a "buffer"
			response.pipe concatStream
			response.on "error", deferred.reject

			# All data hase been received, now handle it
			response.on "end", ->
				fillMatches concatStream.getBody()
				deferred.resolve()

		deferred.promise


	# Loop from A (65) to Z (90)
	# build a url using the letter and handle the url
	parseStationList =  _.flow String.fromCharCode, buildStationListUrl, parseStationListUrl
	parseStationListPromises = (parseStationList(num) for num in [65..90])

Q.allSettled(doStationList())
.then (results)->
	console.log JSON.stringify(stationLists, null, 2)




