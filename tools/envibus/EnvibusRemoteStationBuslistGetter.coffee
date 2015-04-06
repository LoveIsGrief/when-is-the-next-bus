$ = require "cheerio"
_ = require "lodash"
logger = require("log4js").getLogger()
Q = require "q"

r = require("require-root")("project")
RemoteGetter = r("tools/RemoteGetter")

class EnvibusRemoteStationBuslistGetter extends RemoteGetter
	constructor: ->
		@baseUrl = "http://tempsreel.envibus.fr/?ptano="

	buildUrl: (buslineCode)->
		@baseUrl + buslineCode

	###
	Create a DOM from the HTML
	and finds which buses pass by the station

	@param html to be converted to DOM
	@returns {Array} Busline objects for that station
	###
	parseReceivedData: (html)->
		document = $.load html
		trs = document('div.formulaire>table>tr')

		buses = trs.filter ->
			$("input", @).attr("value") != ""
		.map ->
			code = $("input", @).attr("value")
			name = $('label[for*="ligno"]>img', @).attr("alt")
			bus = {
				name: name
				code: code
			}
			logger.debug "parsed bus: ", bus
			bus
		.get()

		logger.debug "parsed buses: ", buses

		buses

	###
	Promise to get the list of buses for a station

	@param stationCode {String}
	@returns a promise with list of buses for the given station
	###
	get: (stationCode)->
		logger.debug "Getting buses for stationcode: #{stationCode}"
		# build a url using the letter and handle the url
		@makeRequest @buildUrl stationCode

module.exports = EnvibusRemoteStationBuslistGetter