Q = require "q"
r = require("require-root")("project")
EnvibusRemoteStationsGetter = r("tools/envibus/EnvibusRemoteStationsGetter")


describe "EnvibusRemoteStationsGetter", ->

		beforeEach ->
			@getter = new EnvibusRemoteStationsGetter

		it "should have a method #get", ->
			expect(@getter.get).toBeDefined()

		it "#get should return a promise", ->
			# Replace with stub, no need to actualy call http.get
			@getter.httpGet = (args...)->

			promise = @getter.get(65,65)
			expect(Q.isPromise(promise)).toBeTruthy()

		it "should promise a map of stations", (done)->
			@getter.get(65,65).then (stations)->
				expect(stations).toBeDefined()
				expect(stations).not.toBeNull()

				keys = Object.keys stations
				expect(keys.length).toBeGreaterThan 0

				done()