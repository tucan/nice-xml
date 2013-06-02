# XML Writer
#
# May, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# XML Writer

class Writer
	# Object constructor

	constructor: (stream) ->

	# Writes opening tag of element

	startElement: (key) ->
		@buffer.push('<' + key + '>')

		@

	# Writes closing tag of element

	endElement: (key) ->
		@buffer.push('</' + key + '>')

		@

	# Writes element and it's content

	pushElement: (key, value) -> @

	# Writes attribute and it's value

	pushAtrribute: (key, value) ->
		# Сделать экранирование спец. символов значения

		@

	#

	pushText: (value) ->
		# Сделать экранирование спец. символов

		@

	#

	pushComment: (value) -> @

# Exported objects

module.exports = Writer
