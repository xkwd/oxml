# frozen_string_literal: true

require 'benchmark'
require 'oxml'
require 'nori'
require 'xmlsimple'
require 'active_support/core_ext/hash/conversions'

xml = File.read("#{__dir__}/sample.xml")

puts 'XML -> Hash:'
runs = 100

Benchmark.bm 30 do |x|
  x.report 'xmlsimple                        ' do
    runs.times { XmlSimple.xml_in(xml) }
  end

  ActiveSupport::XmlMini.backend = 'REXML'
  x.report 'activesupport w/ rexml           ' do
    runs.times { Hash.from_xml(xml) }
  end

  x.report 'nori                             ' do
    runs.times { Nori.new.parse(xml) }
  end

  ActiveSupport::XmlMini.backend = 'Nokogiri'
  x.report 'activesupport w/ nokogiri        ' do
    runs.times { Hash.from_xml(xml) }
  end

  ActiveSupport::XmlMini.backend = 'LibXML'
  x.report 'activesupport w/ libxml          ' do
    runs.times { Hash.from_xml(xml) }
  end

  x.report 'oxml (advanced_typecasting: true)' do
    runs.times { OXML.parse(xml, advanced_typecasting: true) }
  end

  x.report 'oxml                             ' do
    runs.times { OXML.parse(xml) }
  end
end
