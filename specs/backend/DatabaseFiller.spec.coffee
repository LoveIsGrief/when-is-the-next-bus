logger = require("log4js").getLogger()
R = require("require-root")("project")
Q = require "q"

DatabaseFiller = R("src/DatabaseFiller")
EnvibusRemoteNextBusesGetter = R("tools/envibus/EnvibusRemoteNextBusesGetter")
EnvibusRemoteStationBuslistGetter = R("tools/envibus/EnvibusRemoteStationBuslistGetter")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")

logger.setLevel "INFO"

describe "DatabaseFiller" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)

	describe "#updateStationsNextBuses", ->

		beforeEach ->
			@filler = new DatabaseFiller
			@exampleProvider = {
				getBusesForStation: ->
					Q.defer().promise
				getTimesForNextBuses: ->
					Q.defer().promise
			}

			busesGetter = new EnvibusRemoteStationBuslistGetter
			nextBusesGetter = new EnvibusRemoteNextBusesGetter
			@envibusProvider = {
				getBusesForStation: busesGetter.get.bind busesGetter
				getTimesForNextBuses: nextBusesGetter.get.bind nextBusesGetter
			}

		it "should be a callable function", ->
			expect(@filler.updateStationsNextBuses).toBeDefined()
			expect(@filler.updateStationsNextBuses).toBeInstanceOf Function

		it "should return a promise", ->
			expect(@filler.updateStationsNextBuses(@exampleProvider)).toBeInstanceOf Q.makePromise

		it "should promise a list of buses", (done)->
			@filler.updateStationsNextBuses(@envibusProvider, "999")
			.then (buses)->
				expect(buses).toBeDefined()
				expect(buses).toBeInstanceOf Array
				expect(buses.length).toBeGreaterThan 0
				done()