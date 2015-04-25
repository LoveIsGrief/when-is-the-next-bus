logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

DatabaseFillerWorker = R("src/DatabaseFillerWorker")
EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")
objectShouldHaveMethod = R("specs/helpers/objectShouldHaveMethod")(expect)

logger.setLevel "INFO"

sampleGetter =
	inject: (providername)->

		switch providername
			when "envibus"
				getter = new EnvibusRemoteNextBusesGetter
				getNextBusesForStation: getter.get.bind getter
			when "test"
				getNextBusesForStation: ->
					Q.fcall ->
			else
				getNextBusesForStation: (args...)->
					Q.fcall ->
						throw "provider #{providername} unknown"


describe "DatabaseFillerWorker" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)
		@worker = new DatabaseFillerWorker

	describe "#writeToDb", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "writeToDb")

	describe "#onMessage", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "onMessage")

	describe "#start", ->

		it "should be an existing function"
			, objectShouldHaveMethod("worker", "start")

	xdescribe "#updateStationsNextBuses", ->

		beforeEach ->
			@worker = new DatabaseFillerWorker {
				envibus: [
					"999"
				]
			}, sampleGetter

		it "should be a callable function"
			, objectShouldHaveMethod("worker", "updateStationsNextBuses")

		it "should return a promise", ->
			expect(@worker.updateStationsNextBuses(@exampleProvider)).toBeInstanceOf Q.makePromise

		it "should promise a list of buses", (done)->
			@worker.updateStationsNextBuses(@envibusProvider, "999")
			.then (buses)->
				expect(buses).toBeDefined()
				expect(buses).toBeInstanceOf Array
				expect(buses.length).toBeGreaterThan 0
				done()