#! /usr/bin/env coffee

global.XML = require('..').XML

#

test = (strategy, data, count) ->
	strategy.stringify(data) for i in [0...count]

# Start of the benchmark

obj = require('./data.json')

strategy = global[process.argv[2]]
count = Number(process.argv[3])

console.log strategy.stringify(obj)

test(strategy, obj, count)
