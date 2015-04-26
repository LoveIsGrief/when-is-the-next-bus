logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

DatabaseFillerWorker = R("src/DatabaseFillerWorker")
EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")
objectShouldHaveMethod = R("specs/helpers/objectShouldHaveMethod")(expect)

logger.setLevel "INFO"

describe "DatabaseFillerWorker" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)

		@eventEmitter = on: ->
		spyOn @eventEmitter, "on"

		@worker = new DatabaseFillerWorker @eventEmitter

	describe "#writeToDb", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "writeToDb")

	describe "#onMessage", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "onMessage")

	describe "#start", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "start")

		it "should register the #onMessage handler", ->
			@worker.start()
			expect(@eventEmitter.on).toHaveBeenCalledWith "message", @worker.onMessage


	describe "#updateStationsNextBuses", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "updateStationsNextBuses")

		it "should return a promise", ->
			expect(@worker.updateStationsNextBuses()).toBeInstanceOf Q.makePromise

		it "should promise a call to #writeToDb", (done)->
			spyOn @worker, "writeToDb"
			@worker.updateStationsNextBuses().then =>
				expect(@worker.writeToDb).toHaveBeenCalled()
				done()