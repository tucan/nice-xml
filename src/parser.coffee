# Copyright Vladimir Andreev

# Required modules

Reader = require('./reader')

# XML parser

class Parser
	#

	constructor: () ->

	#

	_onOpenTag: (name) ->
		@_object[name] = null

	#

	_onCloseTag: (name) ->

	#

	_onText: (value) ->

	#

	_onPI: (target, value) ->
		@_object.$pi = null

	#

	_onComment: (value) ->
		@_object.$text = null

	#

	process: (text) ->
		@_data = {}

		@_object = {}

		# Должен передать функцию-колбек или себя в Reader

# Exported objects

module.exports = Parser
