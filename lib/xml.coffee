# XML converter
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

Serializer = require('./serializer')

# XML converver

XML =
	# Parses given string to native data types

	parse: (string) ->

	# Stringifies provided data to XML

	stringify: (data) -> new Serializer(data).toString()

# Exported objects

module.exports = XML
