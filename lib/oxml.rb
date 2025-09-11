# frozen_string_literal: true

require 'stringio'
require 'ox'

require_relative 'oxml/version'
require_relative 'oxml/utils'
require_relative 'oxml/parser'
require_relative 'oxml/builder'

module OXML
  IO_OPTIMIZATION_THRESHOLD = 1_048_576 # 1MB in bytes

  module_function

  def parse(xml, options = {})
    handler = Parser.new(options)
    ox_options = {}.tap do |hash|
      hash[:encoding] = 'UTF-8' if options[:force_utf8]
      hash[:skip] = :skip_return if options[:preserve_white_space]
    end

    Ox.default_options = ox_options unless ox_options.empty?
    xml_input = optimize_xml_input(xml)
    Ox.sax_parse(handler, xml_input)
    handler.to_h
  end

  def build(hash)
    Builder.new(hash).to_s
  end

  # Use StringIO for large strings to reduce memory allocation
  def optimize_xml_input(xml)
    return xml unless xml.is_a?(String) && xml.bytesize > IO_OPTIMIZATION_THRESHOLD

    StringIO.new(xml)
  end
end
