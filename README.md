# OXML

OXML is a fast Ruby XML to Hash parser, built on top of the [Ox](https://github.com/ohler55/ox) gem (a native C extension).

```ruby
  require 'oxml'

  options = {
    strip_namespaces: true || false,
    delete_namespace_attributes: true || false,
    advanced_typecasting: true || false,
    skip_soap_elements: true || false,
  }

  OXML.parse(xml, options)
```

### Benchmarks

```
XML -> Hash:
                           user     system      total        real
xmlsimple                  0.477219   0.013127   0.490346 (  0.490372)
activesupport w/ rexml     0.434693   0.005745   0.440438 (  0.440469)
nori                       0.108569   0.008505   0.117074 (  0.117098)
activesupport w/ nokogiri  0.065717   0.001351   0.067068 (  0.067069)
activesupport w/ libxml    0.052466   0.000904   0.053370 (  0.053374)
oxml                       0.030874   0.000326   0.031200 (  0.031203)
```
