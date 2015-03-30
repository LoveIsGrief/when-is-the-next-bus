fs = require "fs"
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

			# TODO split this into a live test as the results keep changing
			it "should promise a list of busline objects", (done)->
				@getter.get("999").then (buses)->
					expect(buses).toBeDefined()
					expect(buses).not.toBeNull()

					expect(buses.length).toBeGreaterThan 0

					done()

		describe "parseReceivedData", ->

			it "should have a method #parseReceivedData", ->
				expect(@getter.parseReceivedData).toBeDefined()

			it "should return an array with an empty string", ->
				array = @getter.parseReceivedData ""
				expect(array instanceof Array).toBeTruthy()

			it "should return a filled array with valid html", ->
				array = @getter.parseReceivedData fs.readFileSync "specs/assets/envibus/station999.html"
				expect(array.length).toBeGreaterThan 0

				firstBus = array.pop()
				expect(firstBus.name).toBeDefined()
				expect(firstBus.code).toBeDefined()

