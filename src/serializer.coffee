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
		value = value.valueOf() if typeof value is 'object'
		
		if typeof value is 'object'
			@buffer.push('<', key, '>')

			@stringifyObject(value)

			@buffer.push('</', key, '>')
		else
			@buffer.push('<' + key + '>', value, '</' + key + '>')

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
