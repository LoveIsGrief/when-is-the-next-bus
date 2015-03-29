Q = require "q"
r = require("require-root")("project")
EnvibusRemoteStationsGetter = r("tools/envibus/EnvibusRemoteStationsGetter")


describe "EnvibusRemoteStationsGetter", ->

		beforeEach ->
			@getter = new EnvibusRemoteStationsGetter

		describe "get", ->

			it "should should be a method", ->
				expect(@getter.get).toBeDefined()
				expect( typeof @getter.get).toEqual "function"

			it "should return a promise", ->
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