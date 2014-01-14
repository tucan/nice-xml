# Copyright Vladimir Andreev

# TODO
#
# Tag names and attr names checks
# Text and attr values escaping

# XML writer

class Writer
	# Object constructor

	constructor: (options) ->
		#@_space = options.space

		@_buffer = []
		@_empty = null

	# Starts new element with given name

	startElement: (name) ->
		@_buffer.push('>') if @_empty

		@_buffer.push('<', name)
		@_empty = true

		@

	#

	endElement: (name) ->
		if @_empty
			@_buffer.push('/>')
		else
			@_buffer.push('</', name, '>')

		@

	#

	pushAttribute: (name, value) ->
		@_buffer.push(' ', name, '="', value, '"')

		@

	# Pushes new element with given name and value

	pushElement: (name, value) ->
		@_buffer.push('>') if @_empty
		@_empty = false

		@_buffer.push('<', name, '>', value, '</', name, '>')

		@

	#

	pushText: (value) ->
		@_buffer.push('>') if @_empty
		@_empty = false

		@_buffer.push(value)

		@

	#

	pushSection: (value) ->
		@_buffer.push('>') if @_empty
		@_empty = false

		@_buffer.push('<![CDATA[', value, ']]>')

		@

	#

	pushComment: (value) ->
		@_buffer.push('>') if @_empty
		@_empty = false

		@_buffer.push('<!--', value, '-->')

		@

	#

	result: () -> @_buffer.join('')

# Exported objects

module.exports = Writer
