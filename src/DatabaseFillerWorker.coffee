logger = require("log4js").getLogger()

class DatabaseFillerWorker

	constructor: (@getters, @eventEmitter=process)->


	writeToDb: (args...)->
		logger.debug args

	updateStationsNextBuses: (provider, stationCode)->
		@getters.inject(provider).getNextBusesForStation(stationCode)
		.then (buses)=>
			@writeToDb provider, stationCode, buses

	onMessage: (message)=>
		logger.info "Got: ", message
		try
			providerStationPair = message
			if (typeof providerStationPair) is "string"
				providerStationPair = JSON.parse message

			@updateStationsNextBuses providerStationPair.provider
				, providerStationPair.stationCode
			.then =>
				providerStationPair.status = "OK"
				@eventEmitter.send message

		catch anError
			logger.error anError
			error = "Couldn't parse message #{message}"
			@eventEmitter.send {
				status: "KO"
				error: error
			}


	start: ->
		@eventEmitter.on "message", @onMessage


# When executed that means we want to start a worker
if require.main is module
	logger.info "started DatabaseFillerWorker"
	(new DatabaseFillerWorker).start()

module.exports = DatabaseFillerWorker