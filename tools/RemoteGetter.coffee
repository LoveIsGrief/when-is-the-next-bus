ConcatStream = require "concat-stream"
Http = require "http"
Q = require "q"

###
Base class for getting stuff from other servers.

The basic flow is:

get->buildUrl->makeRequest->parseReceivedData

###
class RemoteGetter

	httpGet: Http.get

	###
	Should create an URL to pass to @see makeRequest
	###
	buildUrl: (data)->
		throw "buildUrl not implemented!"

	###
	Parses the data received from @see makeRequest
	###
	parseReceivedData: (data)->
		throw "parseReceivedData not implemented!"

	###
	Wrapper around @see http.get for getting all the remote data
	and passing it on to @see parseReceivedData

	@returns {Q.Promise}
	###
	makeRequest: (url)->
		deferred = Q.defer()

		@httpGet url, (response)=>
			concatStream = new ConcatStream {encoding: "string"}
			response.pipe concatStream
			response.on "error", deferred.reject

			response.on "end", =>
				deferred.resolve @parseReceivedData(concatStream.getBody())

		deferred.promise

	###
	Main method.
	@returns {Q.Promise}
	###
	get: ->
		throw "get not implemented!"

module.exports = RemoteGetter
