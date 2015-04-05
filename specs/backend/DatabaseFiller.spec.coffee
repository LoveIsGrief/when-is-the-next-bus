R = require("require-root")("project")
Q = require "q"

DatabaseFiller = R("src/DatabaseFiller")
toBeInstanceOf = R("specs/matchers/toBeInstanceOf")

describe "DatabaseFiller" , ->

	beforeEach ->
		toBeInstanceOf(jasmine)

	describe "#updateAllStationsNextBuses", ->

		beforeEach ->
			@filler = new DatabaseFiller

		it "should be a callable function", ->
			expect(@filler.updateAllStationsNextBuses).toBeDefined()
			expect(@filler.updateAllStationsNextBuses).toBeInstanceOf Function

		it "should return a promise", ->
			expect(@filler.updateAllStationsNextBuses()).toBeInstanceOf Q.makePromise

