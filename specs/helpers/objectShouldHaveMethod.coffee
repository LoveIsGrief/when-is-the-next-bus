###
A helper for jasmine specs.

@param expect {Function} The the Jasmine `expect` function
@returns a function that will will return a first class function.
###
module.exports = (expect)->

	###
	First class function that returns a function that checks if
	the the object has the given method.

	The object is either taken from the parameter
	or from the `this` object / current context

	@param objectOrName {Object|String} Either the object of name of the object in the context the returned function will be called.
	@param methodName {String} What's your method called?

	@returns {Function}
	###
	objectShouldHaveMethod = (objectOrName,methodName)->
		->
			object = if objectOrName and typeof objectOrName == "object"
				objectOrName
			else
				@[objectOrName]

			method = object[methodName]
			expect(method).toBeDefined()
			expect(method).toBeInstanceOf Function
