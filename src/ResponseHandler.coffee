###
Supposed to be abstract base class for handling AJAX responses from providers

The success and error methods of a request should be passed for an AJAX call

###
class ResponseHandler

	constructor: (string)->

	success: (data)->
		throw "Not implemented!"

	error: (data)->
		throw "Not implemented!"

module.exports = ResponseHandler