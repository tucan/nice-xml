# XML serializer
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# XML serializer

class Serializer
	# Object constructor

	constructor: (@data) ->

	# Writes attribute to current position

	writeAttribute: (key, value) ->
		@buffer.push(' '  + key + '="' + value + '"')

		@

	# Writes element to current position

	writeElement: (key, value) ->
		@buffer.push('<' + key + '>')

		value = value.valueOf() if typeof value is 'object'
		if typeof value is 'object' then @stringifyObject(value) else @buffer.push(value)

		@buffer.push('</' + key + '>')

		@

	#

	inspect: () -> @toString()

	# Returns XML string

	toString: () ->
		@buffer = ['<?xml version="1.0"?>']

		@stringifyObject(@data)

		@buffer.join('')

# Exported objects

module.exports = Serializer
