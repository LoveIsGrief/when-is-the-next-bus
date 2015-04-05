###
Checks if actual is instanceof expected
@param actual {Object}
@param expected {Class}
@returns {Ojbect} with `pass` key.
###
toBeInstanceOf = (actual, expected)->
	pass: (actual instanceof expected)

module.exports = (jasmine)->
	jasmine.addMatchers
		toBeInstanceOf: (args...)->
			compare: toBeInstanceOf
