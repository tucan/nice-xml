#! /usr/bin/env coffee

# Required modules

XML = require('..')

text = '<!--Love--><!----><!--Only one-->'
text = '<hello id="12345">My Love<![CDATA[ Only]]><test>Data</test><item name="cat"/><item>Yes</item><item/></hello>'

data = XML.parse(text)

console.log data
