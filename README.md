# OXML

OXML is a fast Ruby XML to Hash parser, built on top of the [Ox](https://github.com/ohler55/ox) gem (a native C extension).

```ruby
  require 'oxml'

  options = {
    strip_namespaces: true || false,
    delete_namespace_attributes: true || false,
    advanced_typecasting: true || false,
  }

  OXML.parse(xml, options)
```
