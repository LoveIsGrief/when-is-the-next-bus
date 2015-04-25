ChildProcess = require "child_process"
createPool = require("generic-pool").Pool
_ = require "lodash"
logger = require("log4js").getLogger()
RR = require "require-root"

class DatabaseFiller

	constructor: (@updateInterval=5000, @eventEmitter=process)->
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
		@pool = null
		@providerdata = {}
		@providerStationPairs = []
		@workerFilePath = RR.findRoot("project") + "/src/DatabaseFillerWorker.coffee"

	###
	Gets the providerdata from a predefined source
	###
	initProviderData: ->

	###
	Creates pairs from the providerdata
	###
	initProviderStationPairs: ->
		for provider, stationData of @providerdata
			for stationCode of stationData
				@providerStationPairs.push {
					provider: provider
					stationCode: stationCode
				}

	###
	Creates a thread pool
	###
	initPool: ->
		return if @pool
		@pool = createPool
			name: "DatabaseFillerWorkersPool"
			create: @createChildWorker
			min: @getMinNumberOfChildren()
			max: @getMaxNumberOfChildren()
			idleTimeoutMillis: @updateInterval*2
			reapIntervalMillis: @updateInterval
			validate: @isChildWorkerValid
			log: (string, level)->
				if level is "verbose"
					logger.trace string
				else
					logger[level] string


	createChildWorker: (callback)=>
		child = ChildProcess.fork @workerFilePath
		# Let it notify its presence before we say it's ok to use
		# child.stdout.on "data", (data)->
		callback child
	killChildWorker:(child)=>
		child.kill()
	isChildWorkerValid: (child)=>
		child.connected

	###
	TODO calculation depending on number of pairs
	###
	getMaxNumberOfChildren: ->
		10
	###
	TODO calculation depending on number of pairs
	###
	getMinNumberOfChildren: ->
		1

	###
	Adds async actions to update the stations ASAP
	###
	initQueue: ->
		oldInterval = @updateInterval
		@updateInterval = 1

		@providerStationPairs.forEach @enqueueUpdate

		@updateInterval = oldInterval

	###
	Queues a next update, that can be monitored
	and cleared if necessary.
	When stopping, enqueues are denied.

	@param pair {ProviderStationPair} Pair to be updated
	###
	enqueueUpdate: (pair)=>
		return if @stopping

		timerId = @nextTimerId
		@nextTimerId = @nextTimerId + 1

		dequeueFunc = @dequeueUpdate.bind @, timerId, pair

		@timeouts[timerId]=setTimeout dequeueFunc
			, @updateInterval

	###
	Removes the timerId from the queue
	and processes the pair with a worker from the pool
	if possible.

	@param timerId {Integer}
	@param pair {ProviderStationPair}
	###
	dequeueUpdate: (timerId, pair)->
		logger.info "Handling pair(#{timerId}): #{pair}"
		delete @timeouts[timerId]

		@pool.acquire (error, childWorker)=>
			if error
				@enqueueUpdate pair
			else
				@makeChildWork childWorker, pair

	###
	Them little brats gotta work, eh?

	@param childWorker {ChildProcess} basic running childprocess
	@param pair {ProviderStationPair} data the childworker should treat
	###
	makeChildWork: (childWorker, pair)->
		childWorker.send pair

	################################################
	###############Handlers#########################
	################################################

	###
	Enqueues the pair to be handled again.

	@param message {ResponseObject}
		{
			status: "String OK|KO"
			pair:
				provider: "String"
				stationCode: "String"
		}
	###
	handleWorkerResponse: (message)=>
		pair = message.pair
		if message.status == "OK"
			logger.info "Handled #{pair}"
		else if pair
			logger.error "Failed handling #{pair}"
		else if not pair
			logger.error "No pair in message: ", message

		@enqueueUpdate pair if pair


	###
	Initial updates of the db that will enqueue themselves
	###
	start: ->
		@initProviderData()
		@initProviderStationPairs()
		@initPool()
		@initQueue()


		# Register a handler for the responses from finished workers
		@eventEmitter.on "message", @handleWorkerResponse

	###
	Graceful shutdown. Waits till all requests are done
	and prevents any new ones from being made.
	###
	stop: ->
		return if @stopping

		logger.debug "Stopping...."

		# Clear queue and prevent new items to be queued
		@stopping = true
		for timerId, timer of @timeouts
			clearTimeout timer

		# Waits until all processes have idled out
		return if not @pool
		@pool.drain =>
			@pool.destroyAllNow()

# Start up a filler if the file is being run directly
if require.main is module
	(new DatabaseFiller).start()


module.exports = DatabaseFiller