# OXML

OXML is a fast XML to Hash parser and a Hash to XML builder, built on top of the [Ox](https://github.com/ohler55/ox) gem (a native C extension).

### XML parser [ XML -> Hash ]

```ruby
require 'oxml'

options = {
  strip_namespaces: true || false,
  delete_namespace_attributes: true || false,
  advanced_typecasting: true || false, # see benchmarks below for how much it slows down the parsing
  skip_soap_elements: true || false,
}
```

```xml
xml = %(
  <nodes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceProtocol">
    <services>
      <serviceId>
        <id>100</id>
        <statusId>400</statusId>
      </serviceId>
      <updateId>500</updateId>
    </services>
    <time>2023-10-20T05:05:00.000+01:00</time>
    <type>
      <id>9000</id>
      <mode>
        <id>2828288</id>
        <protocol>7000</protocol>
      </mode>
    </type>
    <informations>2</informations>
    <informations>17</informations>
  </nodes>
  <nodes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceShop">
    <services>
      <serviceId>
        <id>400</id>
        <statusId>500</statusId>
      </serviceId>
      <updateId>600</updateId>
    </services>
    <note>Text  with extra  spaces     </note>
  </nodes>
)
```

```ruby
OXML.parse(xml, options) # =>

{
  nodes: [
    {
      "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
      "@xsi:type": 'ns4:ServiceProtocol',
      services: [
        { service_id: { id: '100', status_id: '400' }, update_id: '500' },
      ],
      time: '2023-10-20T05:05:00.000+01:00',
      type: {
        id: '9000', mode: { id: '2828288', protocol: '7000' }
      },
      informations: %w[2 17]
    },
    {
      "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
      "@xsi:type": 'ns4:ServiceShop',
      services: [
        { service_id: { id: '400', status_id: '500' }, update_id: '600' },
      ],
      note: 'Text  with extra  spaces     ',
    }
  ]
}
```

### XML builder [ Hash -> XML ]

```ruby
require 'oxml'

hash = {
  'service' => {
    "@xmlns:xsi": 'http://www.w3.org/2001/XMLSchema-instance',
    "@xsi:type": 'ns4:ServiceProtocol',
    'salePoint' => 578_920,
    'status' => {
      'noTransaction' => '2829999',
      'codeState' => '1'
    },
    'nodes' => {
      'node' => [1, 2, 3].map do |carrier|
        {
          'noCarrier' => carrier,
          'typePlace' => '100'
        }
      end
    }
  }
}

OXML.build(hash) # => see the XML below
```

```xml
<service xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="ns4:ServiceProtocol">
  <salePoint>578920</salePoint>
  <status>
    <noTransaction>2829999</noTransaction>
    <codeState>1</codeState>
  </status>
  <nodes>
    <node>
      <noCarrier>1</noCarrier>
      <typePlace>100</typePlace>
    </node>
    <node>
      <noCarrier>2</noCarrier>
      <typePlace>100</typePlace>
    </node>
    <node>
      <noCarrier>3</noCarrier>
      <typePlace>100</typePlace>
    </node>
  </nodes>
</service>
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
Hash -> XML:
                                   user     system      total        real
gyoku                              0.132535   0.002074   0.134609 (  0.134613)
oxml                               0.044027   0.000907   0.044934 (  0.044937)
