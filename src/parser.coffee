# Copyright Vladimir Andreev

# Required modules

SAX = require('sax')

# XML parser

class Parser
	#

	constructor: (options) ->
		@_empty = options.empty

		@_tree = null
		@_stack = null
		@_current = null

		@_sax = SAX.parser(true)

		@_sax.onopentag = @_onOpenTag
		@_sax.onclosetag = @_onCloseTag
		@_sax.ontext = @_onText
		@_sax.oncdata = @_onCDATA

	#

	_onOpenTag: (options) =>
		if Object.keys(options.attributes).length
			current = $: options.attributes
		else
			current = null

		if @_current is null
			@_current = {}
		else if typeof @_current is 'string'
			@_current = $text: @_current

		@_stack.push([options.name, @_current])
		@_current = current

		undefined

	#

	_onCloseTag: (name) =>
		[tag, prev] = @_stack.pop()

		unless prev[tag]?
			prev[tag] = @_current
		else unless Array.isArray(prev[tag])
			prev[tag] = [prev[tag], @_current]
		else
			prev[tag].push(@_current)

		@_current = prev

		undefined

	#

	_onText: (value) =>
		isGarbage = true

		for char in value
			unless char in ['\n', '\t', ' ']
				isGarbage = false
				break

		return if isGarbage

		if @_current is null
			@_current = value
		else if typeof @_current is 'string'
			@_current += value
		else
			unless @_current.$text?
				@_current.$text = value
			else unless Array.isArray(@_current.$text)
				@_current.$text = [@_current.$text, value]
			else
				@_current.$text.push(value)

		undefined

	#

	_onCDATA: (value) =>
		if @_current is null
			@_current = {}
		else if typeof @_current is 'string'
			@_current = $text: @_current

		@_current.$section = value

		undefined

	#

	process: (text) ->
		@_tree = {}
		@_stack = []
		@_current = @_tree

		@_sax.write(text).close()

		@_tree

# Exported objects

module.exports = Parser
