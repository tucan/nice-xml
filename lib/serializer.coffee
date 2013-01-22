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

	#

	inspect: () -> @toString()

	#

	writeElement: (key, value) ->
		@buffer.push("<#{key}>")

		if typeof value is 'object' then @stringifyObject(value) else @buffer.push(value)

		@buffer.push("</#{key}>")

		@

	# array -> elements

	stringifyArray: (key, data) ->
		@stringifyAny(key, value) for value in data

		@

	# object -> attributes
	
	#writeAttributes: () ->

	# object -> elements

	stringifyObject: (data) ->
		@stringifyAny(key, value) for key, value of data when key[0] isnt '$' and value?

		@

	# key and value -> attribute

	#writeAttribute: () ->
	
	# key and value -> element(s)

	stringifyAny: (key, value) ->
		# Try to get primitive value

		value = value.valueOf() if typeof value is 'object'

		# If value is array

		if Array.isArray(value) then @stringifyArray(key, value)

		# Otherwise

		else @writeElement(key, value)

		@

	#

	toString: () ->
		@buffer = ['<?xml version="1.0"?>']

		@stringifyObject(@data)

		@buffer.join('')

# Exported objects

module.exports = Serializer
