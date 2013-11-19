# XML serializer
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

Writer = require('./writer')

# XML serializer

class Serializer
	#

	constructor: () ->
		@writer = new Writer()

	#

	stringifyPrimitive: (key, value) ->
		@writer.startElement(key)

		value = value.valueOf() if typeof value is 'object'
		if typeof value is 'object' then @stringifyObject(value) else @writer.pushText(value)

		@writer.endElement(key)

		@

	# Serializes array of items

	stringifyArray: (key, data) ->
		@stringifyAny(key, value) for value in data

		@

	# object -> elements

	stringifyObject: (data) ->
		@stringifyAny(key, value) for key, value of data when key[0] isnt '$' and value?

		@

	# key and value -> element(s)

	stringifyAny: (key, value) ->
		if Array.isArray(value) then @stringifyArray(key, value) else @stringifyPrimitive(key, value)

		@

	run: (data) ->
		@stringifyObject(data)

		@writer.buffer.join('')

# Exported objects

module.exports = Serializer
