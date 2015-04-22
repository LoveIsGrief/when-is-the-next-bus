logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

DatabaseFiller = R("src/DatabaseFiller")
EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")

logger.setLevel "OFF"

describe "DatabaseFiller" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)
		@filler = new DatabaseFiller

	describe "#constructor", ->

		beforeEach ->
			@filler = new DatabaseFiller

		it "should have correct workerFilePath", ->
			Worker = require @filler.workerFilePath
			expect(Worker).toBeDefined()

	describe "#initProviderStationPairs", ->

		beforeEach ->
			@filler = new DatabaseFiller

		it "should be an existing function", ->
			initProviderStationPairs = @filler.initProviderStationPairs
			expect(initProviderStationPairs).toBeDefined()
			expect(initProviderStationPairs).toBeInstanceOf Function

		describe "empty providerdata", ->

			it "should leave the providerStationPairs empty", ->
				@filler.initProviderStationPairs()
				providerStationPairs = @filler.providerStationPairs
				expect(providerStationPairs).toBeInstanceOf Array
				expect(providerStationPairs.length).toBe 0

		describe "filled providerdata", ->

			beforeEach ->

				@filler.providerdata = {
					provider1:
						stationCode1: {}
						stationCode2: {}
						stationCode3: {}
					provider2:
						stationCode1: {}
						stationCode2: {}
						stationCode3: {}
				}

			it "should fill providerStationPairs", ->
				@filler.initProviderStationPairs()
				providerStationPairs = @filler.providerStationPairs

				expect(providerStationPairs.length).toBe 6

				expect(providerStationPairs).toContain {
					provider: "provider1"
					stationCode: "stationCode1"
				}

	describe "#initPool", ->

		beforeEach ->
			@filler = new DatabaseFiller

		it "should be an existing function", ->
			initPool = @filler.initPool
			expect(initPool).toBeDefined()
			expect(initPool).toBeInstanceOf Function

		describe "first call", ->

			it "should create a new pool", ->
				@filler.initPool()
				pool = @filler.pool
				expect(pool).toBeDefined()
				expect(pool.getName()).toEqual "DatabaseFillerWorkersPool"

	describe "child worker handling", ->

		beforeEach ->
			@filler = new DatabaseFiller

		it "should have #createChildWorker", ->
			createChildWorker = @filler.createChildWorker
			expect(createChildWorker).toBeDefined()
			expect(createChildWorker).toBeInstanceOf Function

		it "should have #killChildWorker", ->
			killChildWorker = @filler.killChildWorker
			expect(killChildWorker).toBeDefined()
			expect(killChildWorker).toBeInstanceOf Function

		it "should have #isChildWorkerValid", ->
			isChildWorkerValid = @filler.isChildWorkerValid
			expect(isChildWorkerValid).toBeDefined()
			expect(isChildWorkerValid).toBeInstanceOf Function

		it "should be able to create and kill a child worker", (done)->

			@filler.createChildWorker (child)=>
				expect(@filler.isChildWorkerValid(child)).toBeTruthy()

				child.on "close", (code,signal)=>
					expect(@filler.isChildWorkerValid(child)).toBeFalsy()
					done()

				@filler.killChildWorker child

		describe "#handleWorkerResponse", ->

				beforeEach ->
					@filler = new DatabaseFiller

				it "should be an existing function", ->
					handleWorkerResponse = @filler.handleWorkerResponse
					expect(handleWorkerResponse).toBeDefined()
					expect(handleWorkerResponse).toBeInstanceOf Function

				it "should enqueue a pair from a valid message", ->
					spyOn @filler, "enqueueUpdate"
					pair = {
						provider: "some provider"
						stationCode: "a code"
					}
					validMessage = {
						status: "OK"
						pair: pair
					}
					@filler.handleWorkerResponse validMessage
					expect(@filler.enqueueUpdate).toHaveBeenCalledWith pair

				it "should enqueue a pair from a valid message with bad a bad status", ->
					spyOn @filler, "enqueueUpdate"
					pair = {
						provider: "some provider"
						stationCode: "a code"
					}
					validMessage = {
						status: "KO"
						pair: pair
					}
					@filler.handleWorkerResponse validMessage
					expect(@filler.enqueueUpdate).toHaveBeenCalledWith pair

				it "should not enqueue a pair from an invalid message", ->
					spyOn @filler, "enqueueUpdate"
					invalidMessage = invalid: "lol"

					@filler.handleWorkerResponse invalidMessage
					expect(@filler.enqueueUpdate).not.toHaveBeenCalled()


	describe "handling updates", ->

		it "should have #enqueueUpdate", ->
			enqueueUpdate = @filler.enqueueUpdate
			expect(enqueueUpdate).toBeDefined()
			expect(enqueueUpdate).toBeInstanceOf Function

		it "should have #dequeueUpdate", ->
			dequeueUpdate = @filler.dequeueUpdate
			expect(dequeueUpdate).toBeDefined()
			expect(dequeueUpdate).toBeInstanceOf Function

		describe "enqueuing updates", ->

			beforeEach ->
				@filler = new DatabaseFiller
				@filler.updateInterval = 1
				spyOn @filler, "dequeueUpdate"

			it "should enqueue an time-shifted update", (done)->

				timeouts = Object.keys(@filler.timeouts)
				expect(timeouts.length).toBe 0
				@filler.enqueueUpdate "not important"


				timeouts = Object.keys(@filler.timeouts)
				expect(timeouts.length).toBe 1

				setTimeout =>
					expect(@filler.dequeueUpdate).toHaveBeenCalled()
					done()
				, 1

		describe "dequeuing updates", ->

			beforeEach ->
				@filler = new DatabaseFiller
				@filler.updateInterval = 1

				@pool = acquire: ->
				spyOn @pool, "acquire"
				@filler.pool = @pool

			it "should remove a timeout from timeouts object", ->
				timeoutId = 12345
				@filler.timeouts[timeoutId] = "a mock timeout object"
				timeouts = Object.keys @filler.timeouts
				expect(timeouts.length).toBe 1

				@filler.dequeueUpdate timeoutId, "not important"

				timeouts = Object.keys @filler.timeouts
				expect(timeouts.length).toBe 0

				expect(@pool.acquire).toHaveBeenCalled()

