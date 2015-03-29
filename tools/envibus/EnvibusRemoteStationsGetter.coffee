_ = require "lodash"
Q = require "q"

r = require("require-root")("project")
RemoteGetter = r("tools/RemoteGetter")

class EnvibusRemoteStationsGetter extends RemoteGetter
	constructor: ->
		@baseUrl = "http://tempsreel.envibus.fr/list/?com_id=0&letter="
		@regex = /href="..\/\?ptano=([\d$]+)([\w\s]+)"/g

	buildUrl: (letter)=>
		@baseUrl + letter

	###
	Applies a regex to the html

	@param html to be parsed using our regex
	@returns {Object} Simple stationName to stationCode map
	###
	parseReceivedData: (html)=>
		match = null
		stations = {}
		while ((match = @regex.exec(html)) != null)
			if match.index == @regex.lastIndex
				@regex.lastIndex++

			stations[match[2]] = match[1]

		stations

	###
	Gets all stations with the first letters from beginning to end
	Default loop from A (65) to Z (90)

	@param beginning {Number} (optional) A charcode
		default is 65 for 'A'
	@param end {Number} (optional) A charcode
		default is 90 for 'Z'

	@returns a promise with the stations
	###
	get: (beginning = 65,end = 90)->

		# build a url using the letter and handle the url
		action =  _.flow String.fromCharCode, @buildUrl, @makeRequest
		action = _.bind action, @
		actionPromises = (action(num) for num in [beginning .. end])

		Q.allSettled(actionPromises).then (results)->
			stations = {}
			for result in results when result.state is "fulfilled"
				_.merge stations, result.value
			stations

module.exports = EnvibusRemoteStationsGetter