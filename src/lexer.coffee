# Required modules

Events = require('events')
Range = require('./range')

# Constants

# Possible values for "space char"

#SPACE_CHAR_RANGE = Range.union('\x20', '\x09', '\x0d', '\x0a')

SPACE_CHAR_RANGE = has: (char) -> char is ' '

# Possible values for "common char"

###COMMON_CHAR_RANGE = Range.union(
	new Range('\x01', '\ud7ff')
	new Range('\ue000', '\ufffd')
	# [#x10000-#x10FFFF]
)###

COMMON_CHAR_RANGE = has: () -> true

# Possible values for "start name char"

###START_CHAR_RANGE = Range.union(
	':', '_'

	new Range('A', 'Z')
	new Range('a', 'z')

	new Range('\xc0', '\xd6')
	new Range('\xd8', '\xf6')

	new Range('\u00f8', '\u02ff')
	# new Range('\0300', '\u036f')	Combining Diacritical Marks
	new Range('\u0370', '\u037d')
	# '\u037e'	Greek Question Mark
	new Range('\u037f', '\u1fff')
	new Range('\u200c', '\u200d')
	new Range('\u2070', '\u218f')
	new Range('\u2c00', '\u2fef')
	new Range('\u3001', '\ud7ff')
	new Range('\uf900', '\ufdcf')
	new Range('\ufdf0', '\ufffd')
	# [#x10000-#xEFFFF]
)###

START_CHAR_RANGE = has: (char) -> char isnt ' ' and char isnt '?'

# Possible values for "name char"

###NAME_CHAR_RANGE = START_CHAR_RANGE.union(
	'-', '.', '\xb7'

	new Range('0', '9')
	new Range('\u0300', '\u036f')
	new Range('\u203f', '\u2040')
)###

NAME_CHAR_RANGE = has: (char) -> char isnt ' ' and char isnt '?'

#

class Lexer extends Events.EventEmitter
	# Possible lexer states

	STATES =
		# Generic states

		START: 10
		OPEN_BRACKET: 11
		EXCLAMATION: 12

		NONE: undefined
		ERROR: -1

		# CharData states

		CDATA_CONTENT: 20, CDATA_MAYBE_ERROR: 21, CDATA_NEAR_ERROR: 22

		# CharData Section states

		# Reference states

		# Tag states

		OPEN_TAG_NAME: 50, OPEN_TAG_SPACE: 51, OPEN_TAG_SLASH: 52
		CLOSE_TAG_NAME: 53, CLOSE_TAG_SPACE: 54

		# Attribute states

		ATTR_NAME: 60, ATTR_PRE_EQ: 61, ATTR_POST_EQ: 62
		ATTR_DQ_VALUE: 63, ATTR_SQ_VALUE: 64, ATTR_END: 65

		# Comment states

		COMMENT_START: 70, COMMENT_CONTENT: 71
		COMMENT_MAYBE_END: 72, COMMENT_END: 73

		# PI states

		PI_TARGET: 80, PI_TARGET_REST: 81
		PI_CONTENT: 82, PI_END1: 83, PI_END2: 84

	#

	constructor: () ->
		@_state = STATES.START

		@_line = null
		@_column = null

		@_data = {}

	#

	_onStartAlt: () ->
		position = @_position

		if @_text[position...position + 4] is '<!--'
			@_state = STATES.COMMENT_BODY
			@_position += 4

		else if @_text[position...position + 9] is '<![CDATA['
			@_state = STATES.CDATA_BODY
			@_position += 9

		else if @_text[position...position + 2] is '<?'
			@_state = STATES.PI_TARGET
			@_position += 2

		else if @_text[position] is '&'
			@_state = STATES.REFERENCE

		else if START_CHAR_RANGE.has(@_text[position])
			@_state = STATES.TEXT

		else
			@_state = STATES.ERROR

		@_position++

		@

	#		

	_start: () ->
		char = @_text[@_position]

		if char is '<'
			@_position++
			@_state = STATES.OPEN_BRACKET
		else if char is '&'
			@_position++
			@_state = STATES.REFERENCE
		else if START_CHAR_RANGE.has(char)
			@_position++
			@_state = STATES.TEXT
		else
			@_state = STATES.ERROR

		@

	#

	_openBracket: () ->
		char = @_text[@_position]

		if char is '!'
			@_position++
			@_state = STATES.EXCLAMATION
		else if char is '?'
			@_position++
			@_state = STATES.PI_TARGET
		else if START_CHAR_RANGE.has(char)
			@_position++
			@_state = STATES.TAG_NAME
		else
			@_state = STATES.ERROR

		@

	#

	_onExclamation: (char) ->
		switch char
			when '-'
				@_state = STATES.COMMENT_START
			when '['
				@_state = STATES.CDATA_START
			else
				@_state = STATES.ERROR

		@

	#

	_onOpenTagName: (char) ->
		return @ if NAME_CHAR_RANGE.has(char)

		if char is '/'
			@_state = STATES.OPEN_TAG_SLASH
		else if char is '>'
			@_state = STATES.START

		else if SPACE_CHAR_RANGE.has(char)
			@_state = STATES.OPEN_TAG_SPACE
		else
			@_state = STATES.ERROR

		@

	#

	_onOpenTagSpace: (char) ->
		return @ if SPACE_CHAR_RANGE.has(char)

		if char is '/'
			@_state = STATES.OPEN_TAG_SLASH
		else if char is '>'
			@_state = STATES.START

		else
			@_state = STATES.ERROR

		@

	#

	_onOpenTagSlash: (char) ->
		if char is '>'
			@_state = STATES.START
		else
			@_state = STATES.ERROR

		@

	#

	_onCloseTagName: (char) ->
		return @ if NAME_CHAR_RANGE.has(char)

		if char is '>'
			@_state = STATES.START
		else if SPACE_CHAR_RANGE.has(char)
			@_state = STATES.CLOSE_TAG_SPACE
		else
			@_state = STATES.ERROR

		@

	#

	_onCloseTagSpace: (char) ->
		return @ if SPACE_CHAR_RANGE.has(char)

		if char is '>'
			@_state = STATES.START
		else
			@_state = STATES.ERROR

		@

	#

	_commentStart: (char) ->
		if char '-'
			@_state = STATES.COMMENT_CONTENT
		else
			@_state = STATES.ERROR

		@

	#

	_commentContent: (char) ->
		return @ if COMMON_CHAR_RANGE.has(char)

		if char is '-'
			@_state = STATES.COMMENT_MAYBE_END
		else
			@_state = STATES.ERROR

		@

	#

	_commentMaybeEnd: (char) ->
		if COMMON_CHAR_RANGE.has(char)
			@_state = STATES.COMMENT_CONTENT
		else if char is '-'
			@_state = STATES.COMMENT_END
		else
			@_state = STATES.ERROR

		@

	#

	_commentEnd: (char) ->
		if char is '>'
			@_state = STATES.START
		else
			@_state = STATES.ERROR

		@

	#

	_piTarget: () ->
		char = @_text[@_position]

		if START_CHAR_RANGE.has(char)
			@_data.start = @_position

			@_position++
			@_state = STATES.PI_TARGET_REST
		else
			@_state = STATES.ERROR

		@

	#

	_piTargetRest: () ->
		char = @_text[@_position]

		if char is '?'
			@_data.target = @_text[@_data.start...@_position]

			@_position++
			@_state = STATES.PI_END2
		else if SPACE_CHAR_RANGE.has(char)
			@_data.target = @_text[@_data.start...@_position]
			@_data.start = @_position

			@_position++
			@_state = STATES.PI_CONTENT
		else if NAME_CHAR_RANGE.has(char)
			@_position++
		else
			@_state = STATES.ERROR

		@

	#

	_piContent: () ->
		char = @_text[@_position]

		if char is '?'
			@_position++
			@_state = STATES.PI_END1
		else if COMMON_CHAR_RANGE.has(char)
			@_position++
		else
			@_state = STATES.ERROR

		@

	#

	_piEnd1: () ->
		char = @_text[@_position]

		if char is '>'
			target = @_data.target
			@_data.target = null

			content = @_text[@_data.start...@_position - 1]
			@_data.start = null

			@_onPI(target, content)

			@_position++
			@_state = STATES.START
		else if COMMON_CHAR_RANGE.has(char)
			@_position++
			@_state = STATES.PI_CONTENT
		else
			@_state = STATES.ERROR

		@

	#

	_piEnd2: () ->
		char = @_text[@_position]

		if char is '>'
			target = @_data.target
			@_data.target = null

			@_onPI(target, null)

			@_position++
			@_state = STATES.START
		else
			@_state = STATES.ERROR

		@

	#

	_onComment: (content) ->
		console.log(content)

		undefined

	#

	_onPI: (target, content) ->
		console.log(target, content)

		undefined

	#

	process: (text) ->
		@_text = text
		@_position = 0

		@_state = STATES.START

		SIMPLE_HANDLERS =
			'10': '_start'
			'11': '_openBracket'

			'80': '_piTarget'
			'81': '_piTargetRest'
			'82': '_piContent'
			'83': '_piEnd1'
			'84': '_piEnd2'

		# Каждая итерация на токен или группу взаимосвязанных токенов

		while @_position < @_text.length
			console.log @_state, @_text[@_position]
			@[SIMPLE_HANDLERS[@_state]]()

		@

# Exported objects

module.exports = Lexer
