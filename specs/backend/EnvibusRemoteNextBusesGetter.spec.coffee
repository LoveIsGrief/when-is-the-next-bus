fs = require "fs"
Q = require "q"
r = require("require-root")("project")
EnvibusRemoteNextBusesGetter = r("tools/envibus/EnvibusRemoteNextBusesGetter")


describe "EnvibusRemoteNextBusesGetter", ->

		beforeEach ->
			@getter = new EnvibusRemoteNextBusesGetter


		describe "get", ->

			it "should have a method #get", ->
				expect(@getter.get).toBeDefined()

			it "should return a promise", ->
				# Replace with stub, no need to actualy call http.get
				@getter.httpGet = (args...)->

				promise = @getter.get("a code")
				expect(Q.isPromise(promise)).toBeTruthy()

			# TODO split this into a live test as the results keep changing
			xit "should promise a list of busline objects", (done)->
				station = "999"
				busCodes = [
					"1"
					"2"
					"3"
					"4"
				]
				@getter.get("999", busCodes).then (nextBuses)->
					expect(nextBuses).toBeDefined()
					expect(nextBuses).not.toBeNull()

					expect(nextBuses.length).toBeGreaterThan 0

					done()

		describe "parseReceivedData", ->

			it "should have a method #parseReceivedData", ->
				expect(@getter.parseReceivedData).toBeDefined()

			it "should return an array with an empty string", ->
				array = @getter.parseReceivedData ""
				expect(array instanceof Array).toBeTruthy()

			it "should return a filled array with valid html", ->
				html = fs.readFileSync "specs/assets/envibus/station999_nextBuses.html"
				array = @getter.parseReceivedData html
				expect(array.length).toBeGreaterThan 0

				firstBus = array.pop()
				expect(firstBus.name).toBeDefined()
				expect(firstBus.direction).toBeDefined()
				expect(firstBus.next).toBeDefined()
				expect(firstBus.following).toBeDefined()

