# frozen_string_literal: true

require 'ox'

require_relative 'oxml/version'
require_relative 'oxml/utils'
require_relative 'oxml/parser'

module OXML
  module_function

  def parse(xml, options = {})
    handler = Parser.new(options)
    Ox.default_options = { encoding: 'UTF-8', skip: :skip_return}
    Ox.sax_parse(handler, xml)
    handler.to_h
  end
end
