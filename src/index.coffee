# Copyright Vladimir Andreev

# Required modules

Parser = require('./parser')
Serializer = require('./serializer')

# Parses given string to native data types

parse = (text, reviver) ->
	new Parser(empty: false).process(text)

# Serializes provided data into string

stringify = (data, replacer, space) ->
	new Serializer(replacer, space).process(data)

# Exported objects

module.exports =
	parse: parse
	stringify: stringify
