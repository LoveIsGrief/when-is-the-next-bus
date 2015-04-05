Q = require "q"

class DatabaseFiller
	constructor: ->

	updateAllStationsNextBuses: (provider, stations)->
		deferred = Q.defer()

		deferred.promise

module.exports = DatabaseFiller