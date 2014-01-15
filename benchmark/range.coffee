#

Range = require('../src/range')

test = (value) ->
	value is ':' or value is '_' or

	value >= 'A' and value <= 'Z' or
	value >= 'a' and value <= 'z' or

	value >= '\xc0' and value <= '\xd6' or
	value >= '\xd8' and value <= '\xf6' or

	value > '\u00f8' and value < '\u02ff' or
	value > '\u0370' and value < '\u037d' or
	value > '\u037f' and value < '\u1fff' or
	value > '\u200c' and value < '\u200d' or
	value > '\u2070' and value < '\u218f' or
	value > '\u2c00' and value < '\u2fef' or
	value > '\u3001' and value < '\ud7ff' or
	value > '\uf900' and value < '\ufdcf'

#

range = Range.union(
	':', '_'

	new Range('A', 'Z')
	new Range('a', 'z')

	new Range('\xc0', '\xd6')
	new Range('\xd8', '\xf6')

	new Range('\u00f8', '\u02ff')
	new Range('\u0370', '\u037d')
	new Range('\u037f', '\u1fff')
	new Range('\u200c', '\u200d')
	new Range('\u2070', '\u218f')
	new Range('\u2c00', '\u2fef')
	new Range('\u3001', '\ud7ff')
	new Range('\uf900', '\ufdcf')
	new Range('\ufdf0', '\ufffd')
)

for index in [0...Number(process.argv[2])]
	range.has('`')
	#test('`')
