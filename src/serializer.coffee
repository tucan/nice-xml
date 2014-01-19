# Copyright Vladimir Andreev

# Required modules

Writer = require('./writer')

# XML serializer

class Serializer
	# Object constructor

	constructor: (replacer, space) ->
		@_buffer = null

	# Serializes object into elements

	_processObject: (data) ->
		@_processAny(key, value) for key, value of data when key isnt '$'

		@

	# Serializes object into attributes

	_processAttrObject: (data) ->
		@_writer.pushAttribute(key, value) for key, value of data

		@

	# Processes array or array-like object

	_processArray: (key, data) ->
		@_processAny(key, value) for value in data

		@

	# Processes key-value pair with regular key

	_processRegular: (key, value) ->
		# For null or simple type value

		if value is null or typeof value isnt 'object'
			@_writer.pushElement(key, value)

		# For any composite type

		else
			@_writer.startElement(key)

			@_processAttrObject(value.$)
			@_processObject(value)

			@_writer.endElement(key)

		@

	# Processes key-value pair with special key

	_processSpecial: (key, value) ->
		switch key
			when '$text'
				@_writer.pushText(value)
			when '$section'
				@_writer.pushSection(value)
			when '$comment'
				@_writer.pushComment(value)
			else
				throw new Error('Unknown special key: ' + key)

		@

	# Processes any non-array type

	_processNonArray: (key, value) ->
		# Try to unwrap object

		value = value.valueOf() if value isnt null and typeof value is 'object'	# BUG: not every object can have this method

		# Key corresponds to element

		unless key[0] is '$'
			@_processRegular(key, value)

		# Key corresponds to Text, CDS, Comment or PI

		else
			@_processSpecial(key, value)

		@

	# Method for routing further procesing

	_processAny: (key, value) ->
		return if value is undefined or typeof value is 'function'

		if Array.isArray(value)
			@_processArray(key, value)
		else
			@_processNonArray(key, value)

		@

	#

	process: (data) ->
		@_writer = new Writer()

		@_processObject(data)

		@_writer.result()

# Exported objects

module.exports = Serializer
