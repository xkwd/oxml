# frozen_string_literal: true

require 'benchmark'
require 'oxml'
require 'gyoku'

xml = File.read("#{__dir__}/sample.xml")
hash = OXML.parse(xml)

puts 'Hash -> XML:'
runs = 100

Benchmark.bm 20 do |x|
  x.report 'gyoku                    ' do
    runs.times { Gyoku.xml(hash) }
  end

  x.report 'oxml                     ' do
    runs.times { OXML.build(hash) }
  end
end
