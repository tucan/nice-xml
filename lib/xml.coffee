# XML converter
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# Required modules

expat = require('node-expat')
XMLWriter = require('xml-writer')

# XML converver

XML =
	# Parses given string to native data types

	parse: (string) ->

	# Stringifies provided data to XML

	stringify: (data) -> @stringifyObject(data)
	
	#

	stringifyAny: (value, key) ->
		result = []

		# If value is array

		if Array.isArray(value)
			result.push(@stringifyArray(value, key))

		# If value is undefined of null

		else unless value?
			result.push('<' + key + '/>')

		# Otherwise

		else
			result.push('<' + key + '>')
			
			switch typeof value
				when 'string' then result.push(value)
				when 'number', 'boolean' then result.push(String(value))
				when 'object' then result.push(@stringifyObject(value))
			
			result.push('<' + key + '/>')

		result.join('')

	#

	stringifyArray: (data, key) ->
		result = []

		result.push(@stringifyAny(value, key)) for value in data

		result.join('')

	#

	stringifyObject: (data) ->
		result = []

		result.push(@stringifyAny(value, key)) for key, value of data

		result.join('')

# Exported objects

exports = module.exports = XML
