# Copyright Vladimir Andreev

# TODO
#
# Tag names and attr names checks
# Text and attr values escaping

# XML serializer

class Serializer
	# Object constructor

	constructor: (replacer, space) ->
		@_buffer = null

	# Processes object

	_processObject: (data) ->
		@_processAny(key, value) for key, value of data when key isnt '$'

		@

	# Processes array or array-like object

	_processArray: (key, data) ->
		@_processAny(key, value) for value in data

		@

	# Processes any non-array type

	_processNonArray: (key, value) ->
		# Try to unwrap object

		value = value.valueOf() if value isnt null and typeof value is 'object'

		# Key represents regular element

		unless key[0] is '$'
			# For null value

			if value is null
				@_buffer.push('<', key, '/>')

			# For any simple value

			else if typeof value isnt 'object'
				@_buffer.push('<', key, '>', value, '</', key, '>')

			# For any composite type

			else
				@_buffer.push('<', key)
				@_buffer.push(' ', attrKey, '="', attrValue, '"') for attrKey, attrValue1 of value.$
				@_buffer.push('>')

				# HANDLE cases where value is $text: null or value is $section: null

				@_processObject(value)

				@_buffer.push('</', key, '>')

		# Key represents special case

		else switch key
			when '$text' then @_buffer.push(value)
			when '$section' then @_buffer.push('<![CDATA[', value, ']]>')
			when '$comment' then @_buffer.push('<!--', value, '-->')
			else throw new Error('Unknown special key: ' + key)

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
		@_buffer = []

		# Нужна проверка на наличие только одного корневого элемента
		# и, возможно, элемента $xml с типом значения не равным массиву
		# Т.е. data - это представление документа

		@_processObject(data)

		@_buffer.join('')

# Exported objects

module.exports = Serializer
