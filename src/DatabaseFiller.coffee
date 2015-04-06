_ = require "lodash"
logger = require("log4js").getLogger()

class DatabaseFiller
	constructor: ->

	updateStationsNextBuses: (provider, stationCode)->
		provider.getBusesForStation(stationCode)
		.then (buses)->
			logger.debug "then buses: ", buses
			busCodes = _.pluck buses, "code"
			logger.debug "buscodes: ", busCodes
			provider.getTimesForNextBuses stationCode, busCodes

module.exports = DatabaseFiller