# xml-objects

XML to JS native objects bidirectional converver

## Reader

This class provides you with SAX parser.

```coffeescript
reader = new Reader()

reader.on('element', (key) ->
	console.log(key)

	undefined
)

reader.on('text', (value) ->
	console.log(value)

	undefined
)

reader.on('comment', (value) ->
	console.log(value)

	undefined
)

reader.on('attribute', (key, value) ->
	console.log(key, value)

	undefined
)

reader.on('error', (error) ->
	console.log(error)
	
	undefined
)
```

## Writer

This class provides you with slighlty modified XMLWriter interface.

```coffeescript
writer = new Writer()

writer.startElement('test')
writer.pushText('some string').pushElement('hello', 12345)
writer.endElement('test')
```

will produce

```xml
<test>some string<hello>12345</hello></test>
```
