Q = require "q"
r = require("require-root")("project")
EnvibusRemoteStationBuslistGetter = r("tools/envibus/EnvibusRemoteStationBuslistGetter")


describe "EnvibusRemoteStationBuslistGetter", ->

		beforeEach ->
			@getter = new EnvibusRemoteStationBuslistGetter


		describe "get", ->

			it "should have a method #get", ->
				expect(@getter.get).toBeDefined()

			it "should return a promise", ->
				# Replace with stub, no need to actualy call http.get
				@getter.httpGet = (args...)->

				promise = @getter.get("a code")
				expect(Q.isPromise(promise)).toBeTruthy()

			xit "should promise a list of busline objects", (done)->
				@getter.get("999").then (buses)->
					expect(buses).toBeDefined()
					expect(buses).not.toBeNull()

					expect(stations.length).toBeGreaterThan 0

					done()

		describe "parseReceivedData", ->

			it "should have a method #parseReceivedData", ->
				expect(@getter.parseReceivedData).toBeDefined()

			it "should return an array with an empty string", ->
				array = @getter.parseReceivedData ""
				expect(array instanceof Array).toBeTruthy()

			xit "should return a filled array with valid html", ->

