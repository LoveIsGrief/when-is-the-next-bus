_ = require "lodash"
logger = require("log4js").getLogger()

class DatabaseFiller

	constructor: (@providerData,@getters,@updateInterval=5000)->
		###
		NodeJS doesn't create timerIDs, but timer-objects
		We need timerIDs
		###
		@nextTimerId = 0
		###
		key-timer container
		###
		@timeouts = {}
		###
		Set when we are stopping the filler
		###
		@stopping = false

	###
	Queues a next update, that can be monitored and cleared if necessary.
	When stopping enqueues are denied

	@param fun {Function} function to be queued
	@param args {} arguments to call fun with
	###
	queueNextUpdate: (fun, args...)->
		return if @stopping

		timerId = @nextTimerId
		@nextTimerId = @nextTimerId + 1

		@timeouts[timerId]=setTimeout =>
			logger.debug timerId
			delete @timeouts[timerId]

			logger.debug "apply args: #{args}"
			fun.apply @, args
		, @updateInterval


	writeToDb: (args...)->
		logger.debug args

	updateStationsNextBuses: (provider, stationCode)->
		@getters.inject(provider).getNextBusesForStation(stationCode)
		.then (buses)=>
			@writeToDb provider, stationCode, buses
		.finally =>
			@queueNextUpdate @updateStationsNextBuses, provider, stationCode

	###
	Initial updates of the db that will enqueue themselves
	###
	start: ->
		for provider, stations of @providerData
			for station in stations
				@updateStationsNextBuses(provider, station)

	###
	Graceful shutdown. Waits till all requests are done
	and prevents any new ones from being made.
	###
	stop: ->
		logger.debug "Stopping...."
		@stopping = true
		for timerId, timer of @timeouts
			clearTimeout timer


module.exports = DatabaseFiller