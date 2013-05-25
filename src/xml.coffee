# XML converter
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

Standard = require('./standard')

# XML converver

XML =
	# Parses given string to native data types

	parse: (string) ->

	# Stringifies provided data to XML

	stringify: (data) -> new Standard(data).toString()

# Exported objects

module.exports = XML
