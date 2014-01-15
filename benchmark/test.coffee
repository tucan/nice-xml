#! /usr/bin/env coffee

global.XML = require('..')

#

test = (strategy, data, count) ->
	strategy.stringify(data) for i in [0...count]

	undefined

# Start of the benchmark

obj = require('./data.json')

strategy = global[process.argv[2]]
count = Number(process.argv[3])

console.log strategy.stringify(obj, null, '\t')

test(strategy, obj, count)
