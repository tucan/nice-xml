#

class Range
	#

	@union: () ->
		data = []

		for range in arguments
			if typeof range is 'object'
				data.push([range._data.start, range._data.finish])
			else
				data.push([range, range])

		result = new Range()

		result._data = data

		result

	#

	constructor: (start, finish, exclusive = false) ->
		@_data = [start, finish]

	#

	union: () -> new @constructor()

	#

	has: (value) ->
		for item in @_data
			return true if value >= item[0] and value <= item[1]

		false

# Exported objects

module.exports = Range
