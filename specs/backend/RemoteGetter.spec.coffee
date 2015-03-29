Q = require "q"
r = require("require-root")("project")
RemoteGetter = r("tools/RemoteGetter")


describe "RemoteGetter", ->

		beforeEach ->
			@getter = new RemoteGetter

		describe "get", ->

			it "should be a function", ->
				expect(@getter.get).toBeDefined()
				expect(typeof @getter.get).toEqual "function"

			it "should throw an exception", ->
				expect(@getter.get).toThrow()

		describe "buildUrl", ->

			it "should be a function", ->
				expect(@getter.buildUrl).toBeDefined()
				expect(typeof @getter.buildUrl).toEqual "function"

			it "should throw an exception", ->
				expect(@getter.buildUrl).toThrow()

		describe "parseReceivedData", ->

			it "should be a function", ->
				expect(@getter.parseReceivedData).toBeDefined()
				expect(typeof @getter.parseReceivedData).toEqual "function"

			it "should throw an exception", ->
				expect(@getter.parseReceivedData).toThrow()

		describe "makeRequest", ->

			beforeEach ->
				@getter = new RemoteGetter
				@getter.httpGet = (args...)->

			it "should be a function", ->
				expect(@getter.makeRequest).toBeDefined()
				expect(typeof @getter.makeRequest).toEqual "function"

			it "should make a promise", ->
				promise = @getter.makeRequest()
				expect(Q.isPromise @getter.makeRequest()).toBeTruthy()

