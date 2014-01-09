# Copyright Vladimir Andreev

# Required modules

Writer = require('./writer')

# XML serializer

class Serializer
	#

	constructor: (spaces) ->
		@_writer = new Writer()

	# Processes array or array like objects

	_processArray: (key, data) ->
		for value in data
			continue if value is undefined or typeof value is 'function'

			if Array.isArray(value)
				@_processArray(key, value)
			else
				@_processNonArray(key, value)

		@

	# Processes objects

	_processObject: (data) ->
		for key, value of data when key isnt '$'
			continue if value is undefined or typeof value is 'function'

			if Array.isArray(value)
				@_processArray(key, value)
			else
				@_processNonArray(key, value)

		@

	# key and value -> element(s)

	_processNonArray: (key, value) ->
		# Try to unwrap object

		value = value.valueOf() if value isnt null and typeof value is 'object'

		# This key represents regular element

		unless key[0] is '$'
			# For any simple type or null

			if value is null or typeof value isnt 'object'
				@_writer.pushElement(key, value)

			# For any composite type

			else
				@_writer.startElement(key)

				@_writer.pushAttribute(key1, value1) for key1, value1 of value.$

				@_processObject(value)
				@_writer.endElement(key)

		@

	process: (data) ->
		@_processObject(data)

		@_writer.buffer.join('')

# Exported objects

module.exports = Serializer
