# Required modules

Range = require('./range')

# Constants

# Possible values for "space char"

SPACE_CHAR_RANGE = Range.union('\x20', '\x09', '\x0d', '\x0a')

# Possible values for "common char"

COMMON_CHAR_RANGE = Range.union(
	new Range('\x01', '\ud7ff')
	new Range('\ue000', '\ufffd')
)

# Possible values for "start name char"

START_CHAR_RANGE = Range.union(
	':', '_'

	new Range('A', 'Z')
	new Range('a', 'z')

	new Range('\xc0', '\xd6')
	new Range('\xd8', '\xf6')

	new Range('\u00f8', '\u02ff')
	new Range('\u0370', '\u037d')
	new Range('\u037f', '\u1fff')
	new Range('\u200c', '\u200d')
	new Range('\u2070', '\u218f')
	new Range('\u2c00', '\u2fef')
	new Range('\u3001', '\ud7ff')
	new Range('\uf900', '\ufdcf')
	new Range('\ufdf0', '\ufffd')
)

# Possible values for "name char"

NAME_CHAR_RANGE = START_CHAR_RANGE.union(
	'-', '.', '\xb7'

	new Range('0', '9')
	new Range('\u0300', '\u036f')
	new Range('\u203f', '\u2040')
)

# Possible lexer states

STATES =
	START: 0

	OPEN_BRACKET: 1		# Найдена открывающая угловая скобка
	EXCLAMATION: 2		# Найден вопросительный знак

	PI_START: 3
	QUESTION: 4
	PI_END: 5

	PI_TARGET: 10	# Начало названия PI
	PI_CONTENT: 11	# Начало содержимого PI

# Helpers

# Checks whether provided char is "space char"

isSpace = (value) -> SPACE_CHAR_RANGE.has(value)

# Checks whether provided char is "common char"

isCommonChar = (value) -> COMMON_CHAR_RANGE.has(value)

# Checks whether provided char is "name start char"

isStartChar = (value) -> START_CHAR_RANGE.has(value)

# Checks whether provided char is "name char"

isNameChar = (value) -> NAME_CHAR_RANGE.has(value)

#

class Token
	#

	@TYPES:
		COMMENT_START: 1
		CDATA_START: 2

	#

	@NAMES:
		'1': 'COMMENT_START'
		'2': 'CDATA_START'

	#

	constructor: (type, value) ->
		@_type = type
		@_value = value

	#

	toString: () -> 'Token type ' + @_type

# Возможнны две реализации парсера:
# - потоковая
# - строчная

# Возможны два интерфейса:
# - EventEmitter
# - TransformStream

#

class Lexer
	#

	constructor: () ->
		@_state = STATES.START

	#

	run: (text) ->
		index = 0

		while index < text.length
			char = text[index]

			switch state
				when STATES.START
					if text[index] is '<'
						state = STATES.OPEN_BRACKET

				when STATES.OPEN_BRACKET
					if current is '!'
						state = STATES.EXCLAMATION

					else if current is '?'
						state = STATES.PI_TARGET
						console.log('PI_START')

					else if isStartChar(current)
						state = STATES.NAME_REST

					else
						console.log('Expected \'!\' or \'?\' but found \'' + text[index] + '\'')
						return

				#when STATES.PI_TARGET

				when STATE.EXCLAMATION
					if index + 2 <= text.length and text.slice(index, index + 2) is '--'
						console.log('COMMENT_START')

					else if index + 7 <= text.length and text.slice(index, index + 7) is '[CDATA['
						console.log('CDATA_START')

					else
						console.log('Expected Comment or CharData start')
						return

			index++

		undefined

#run(input)

#

module.exports =
	isStartChar: isStartChar
	isNameChar: isNameChar
