$ = require "cheerio"
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

			stationLists[match[2]] = {
				code: match[1]
				buses: []
			}


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

# Get the buslines for all given stations
doStationBuses = (aStationsList)->

	baseUrl = "http://tempsreel.envibus.fr/?ptano="
	# creates a URL that we will later parse
	buildUrl = (buslineCode)->
		baseUrl + buslineCode

	# Parses the HTML and finds which buses pass by the station
	fillStationBuses = (stationName, aString)->
		document = $.load aString
		trs = document('div.formulaire>table>tr')

		trs.filter ->
			$("input", @).attr("value") != ""
		.each ->
			code = $("input", @).attr("value")
			name = $('label[for*="ligno"]>img', @).attr("alt")
			bus = {
				name: name
				code: code
			}
			aStationsList[stationName].buses.push bus

	# Gets the HTML to parse
	parseStationsBusListUrl = (stationName, url)->
		deferred = Q.defer()

		Http.get url, (response)->
			concatStream = new ConcatStream {encoding: "string"}
			response.pipe concatStream
			response.on "error", deferred.reject

			response.on "end", ->
				fillStationBuses stationName, concatStream.getBody()
				deferred.resolve()

		deferred.promise

	for name, station of aStationsList
		url = buildUrl station.code
		parseStationsBusListUrl name, url



Q.allSettled(doStationList())
.then (results)->
	Q.allSettled(doStationBuses(stationLists))
.then (results)->
		console.log JSON.stringify(stationLists, null, 2)




