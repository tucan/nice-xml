# XML standard
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

Serializer = require('./serializer')

# XML standard

class Standard extends Serializer
	# object -> attributes
	
	writeAttributes: (data) ->
		@writeAttribute(key, value) for key, value of data

		@

	# array -> elements

	stringifyArray: (key, data) ->
		@stringifyAny(key, value) for value in data

		@

	# object -> elements

	stringifyObject: (data) ->
		@stringifyAny(key, value) for key, value of data when key[0] isnt '$' and value?

		@

	# key and value -> element(s)

	stringifyAny: (key, value) ->
		if Array.isArray(value) then @stringifyArray(key, value) else @writeElement(key, value)

		@

# Exported objects

module.exports = Standard
