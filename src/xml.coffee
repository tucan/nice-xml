# JSON like interface for XML converter
#
# May, 2013 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

Reader = require('./reader')
Writer = require('./writer')

# XML converver

XML =
	# Parses given string to native data types

	parse: (text, reviver) ->

	# Serializes provided data to XML

	stringify: (data, replacer, space) -> new Standard(data).toString()

# Makes XML object similar to JSON one

Object.defineProperties(XML, parse: (enumerable: false), stringify: (enumerable: false))

# Exported objects

module.exports = XML
