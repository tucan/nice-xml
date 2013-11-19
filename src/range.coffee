#

class Range
	#

	constructor: (start, finish) ->
		@_start = start
		@_finish = finish

	#

	has: (value) ->
		result = false

		for item in data
			if Array.isArray(item)
				return true if value > item[0] and value < item[1]
			else
				return true if value is item

		result

# Exported objects

module.exports = Range
