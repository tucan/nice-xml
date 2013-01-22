# XML loader
#
# December, 2012 year
#
# Author - Vladimir Andreev
#
# E-Mail: volodya@netfolder.ru

# XML loader

Loader =
	# Handler for XML-files

	handler: (module) ->
		module.exports = test: true

		undefined

	# Registers handler for XML-files

	register: () ->
		require.extensions['.xml'] = @handler

		undefined

# Exported objects

module.exports = Loader
