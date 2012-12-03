# XML loader
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# XML loader

class Loader
	# Handler for XML-files

	@handler: (module, b, c) ->
		module.exports = '12345'

		undefined

	# Registers handler for XML-files

	@register: () ->
		require.extensions['.xml'] = @handler

		undefined

	# Disabled object constructor

	constructor: () -> throw new Error('Can\'t create instance of static class')

# Exported objects

exports = module.exports = Loader
