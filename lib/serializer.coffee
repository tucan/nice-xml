# XML serializer
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# XML serializer

class Serializer
	#

	constructor: (@data) ->

	#

	stringifyAny: (data, key) ->
		# If data is array

		if Array.isArray(data)
			@stringifyArray(data, key)

		# If data is undefined of null

		else unless data?
			@buffer.push('<' + key + '/>')

		# Otherwise

		else
			switch typeof data
				when 'string' then @buffer.push('<' + key + '>', data)
				when 'number', 'boolean' then @buffer.push('<' + key + '>', String(data))
				when 'object'
					@buffer.push('<' + key)
					@stringifyAttributes(data.$)
					@buffer.push('>')
					@stringifyObject(data)
			
			@buffer.push('</' + key + '>')

		@

	#

	stringifyArray: (data, key) ->
		@stringifyAny(value, key) for value in data

		@

	#

	stringifyObject: (data) ->
		@stringifyAny(value, key) for key, value of data when key isnt '$'

		@

	#

	stringifyAttributes: (data) ->
		@buffer.push(' ' + key + '="' + value + '"') for key, value of data

		@

	#

	toString: () ->
		@buffer = ['<?xml version="1.0"?>']

		@stringifyObject(@data)

		@buffer.join('')

# Exported objects

module.exports = Serializer
