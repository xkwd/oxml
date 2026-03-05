# frozen_string_literal: true

require 'stringio'
require 'ox'

require_relative 'oxml/version'
require_relative 'oxml/utils'
require_relative 'oxml/parser'
require_relative 'oxml/builder'

module OXML
  IO_OPTIMIZATION_THRESHOLD = 524_288 # 0.5MB in bytes

  module_function

  def parse(xml, options = {})
    handler = Parser.new(options)
    ox_options = {}.tap do |hash|
      hash[:encoding] = 'UTF-8' if options[:force_utf8]
      need_preserve = options[:preserve_white_space] ||
        options.key?(:strip_whitespace) || options.key?(:normalize_whitespace)
      hash[:skip] = :skip_return if need_preserve
    end

    xml_input = optimize_xml_input(xml)
    Ox.sax_parse(handler, xml_input, ox_options)
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

  module_function :optimize_xml_input
end
