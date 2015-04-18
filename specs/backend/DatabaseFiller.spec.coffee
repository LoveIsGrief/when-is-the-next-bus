logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

DatabaseFiller = R("src/DatabaseFiller")
EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")

logger.setLevel "INFO"

describe "DatabaseFiller" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)

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
