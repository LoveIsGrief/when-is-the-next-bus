fs = require 'fs'
Q = require 'q'
regex = /href="..\/\?ptano=([\d$]+)([\w\s]+)"/g

# Object to fill
matches = {}

# Match the given string with the regex
# and fills the matches
fillMatches = (aString)->
	m = null
	while ((m = regex.exec(aString)) != null)
		if m.index == regex.lastIndex
			regex.lastIndex++

		matches[m[2]] = m[1]

fillMatches (fs.readFileSync "output.html")

console.log JSON.stringify(matches, null, 2)