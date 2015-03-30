$ = require "cheerio"
fs = require "fs"
_ = require "lodash"
querystring = require "querystring"

r = require("require-root")("project")
RemoteGetter = r("tools/RemoteGetter")

###
Remote getter to @see get the buses
coming up next for a given station.
###
class EnvibusRemoteNextBusesGetter extends RemoteGetter
	constructor: ->
		@baseUrl = "http://tempsreel.envibus.fr/hour/?"
		@directionRegex = /direction ([\w ']+)/
		@nextBusRegex = /Prochain passage dans (\d+ minutes?)/
		@followingBusRegexs = [
			/Passage suivant dans (\d+ minutes?)/
			/Passage suivant p\D+([\d:]+)/
		]

	buildUrl: (stationCode,buslineCodes)->

		aQueryStringObject = {
			ptano: stationCode
			ligno: buslineCodes
		}

		@baseUrl + (querystring.stringify aQueryStringObject)

	###
	Create a DOM from the HTML
	and finds when the buses will pass by the station

	@param html to be converted to DOM
	@returns {Array} Busline objects for that station
	###
	parseReceivedData: (html)->
		document = $.load html
		trs = document('div.result>table tr')

		trs.has "img"
		.map (i,el) =>
			bus = {}

			bus.name = $("img", el).attr("alt")
			text = $(el).text()


			directionRes = @directionRegex.exec text
			bus.direction = directionRes[1] if directionRes

			nextRes = @nextBusRegex.exec text
			bus.next = nextRes[1] if nextRes

			followingRes = null
			for regex in @followingBusRegexs
				followingRes = regex.exec text
				continue if not followingRes

			bus.following = followingRes[1] if followingRes

			bus
		.get()

	###
	Promise to get a list of buses passing next for a station

	If the given buses don't pass by the station... well, though luck.

	@param stationCode {String}
	@param buslineCodes {Array} of buslines codes in simple {String}s
	@returns a promise with list of buses for the given station
	###
	get: (stationCode,buslineCodes)->

		# build a url using the letter and handle the url
		@makeRequest @buildUrl(stationCode,buslineCodes)

module.exports = EnvibusRemoteNextBusesGetter
