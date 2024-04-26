# OXML

OXML is a fast XML to Hash parser and a Hash to XML builder, built on top of the [Ox](https://github.com/ohler55/ox) gem (a native C extension).

```ruby
require 'oxml'

options = {
  strip_namespaces: true || false,
  delete_namespace_attributes: true || false,
  advanced_typecasting: true || false, # see benchmarks below for how much it slows down the parsing
  skip_soap_elements: true || false,
}

OXML.parse(xml, options)
```

### Benchmarks

```
XML -> Hash:
                                   user     system      total        real
xmlsimple                          0.490771   0.008862   0.499633 (  0.499655)
activesupport w/ rexml             0.448687   0.003989   0.452676 (  0.452696)
nori                               0.113621   0.008683   0.122304 (  0.122346)
activesupport w/ nokogiri          0.065353   0.001130   0.066483 (  0.066483)
activesupport w/ libxml            0.052111   0.000889   0.053000 (  0.053017)
oxml (advanced_typecasting: true)  0.049945   0.000629   0.050574 (  0.050580)
oxml                               0.030597   0.000314   0.030911 (  0.030916)
```

```
HASH -> XML:
                                   user     system      total        real
gyoku                              0.132535   0.002074   0.134609 (  0.134613)
oxml                               0.044027   0.000907   0.044934 (  0.044937)
