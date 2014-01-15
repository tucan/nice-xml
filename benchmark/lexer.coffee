#! /usr/bin/env coffee

Lexer = require('../lib/lexer')

#

test = (strategy, text, count) ->
	strategy.process(text) for i in [0...count]

	undefined

# Start of the benchmark

text = '<!--Love--><!--Only One-->'

count = Number(process.argv[2])

test(new Lexer, text, count)
