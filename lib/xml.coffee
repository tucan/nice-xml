# XML converter
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

XMLWriter = require('xml-writer')

# XML converver

XML =
	# Parses given string to native data types

	parse: (string) ->

	# Stringifies data to XML

	stringify: (data) ->
		writer = new XMLWriter()

		writer.startDocument()

		@stringifyObject(data, writer)

		writer.endDocument()

		writer.toString()

	stringifyAny: (data, writer) ->

	stringifyObject: (data, writer) ->
		for key, value of data
			switch typeof value
				when 'string' then writer.writeElement(key, value)
				when 'number', 'boolean' then writer.writeElement(key, String(value))
				when 'object'
					if Array.isArray(value)
						@stringifyArray(key, value, writer)
					else
						writer.startElement(key)
						@stringifyObject(value, writer)
						writer.endElement()

		@

# Exported objects

exports = module.exports = XML
