Q = require "q"
r = require("require-root")("project")
EnvibusRemoteStationsGetter = r("tools/envibus/EnvibusRemoteStationsGetter")


xdescribe "EnvibusProvider", ->

	describe "getting stations", ->

		beforeEach ->
			@provider = new EnvibusProvider

		it "should have a method #getStationList", ->
			expect(@provider.getStationList).toBeDefined()

		it "#getStationList should return a promise", ->
			promise = @provider.getStationList()
			expect(Q.isPromise(promise)).toBeTruthy()

		it "should promise a map of stations", (done)->
			@provider.getStationList().then (stations)->
				expect(stations).toBeDefined()
				expect(stations).not.toBeNull()
				done()

	describe "getting station buses" , ->

		beforeEach ->
			@provider = new EnvibusProvider

		it "should have a method #getBusesForStation", ->
			expect(@provider.getBusesForStation).toBeDefined()

		it "#getBusesForStation should return a promise", ->
			promise = @provider.getBusesForStation()
			expect(Q.isPromise(promise)).toBeTruthy()