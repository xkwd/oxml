# frozen_string_literal: true

module OXML
  class Parser
    EMPTY_STR = ''
    TRUE_STR = 'true'
    FALSE_STR = 'false'
    DATE_TIME = /^-?\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})?$/.freeze
    DATE = /^-?\d{4}-\d{2}-\d{2}(?:Z|[+-]\d{2}:?\d{2})?$/.freeze
    TIME = /^\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})?$/.freeze

    def initialize(options = {})
      @memo = {}
      @arr = []
      @map = {}
      @name = nil
      @strip_namespaces = options.fetch(:strip_namespaces, false)
      @delete_namespace_attributes = options.fetch(:delete_namespace_attributes, false)
      @advanced_typecasting = options.fetch(:advanced_typecasting, false)
      @skip_soap_elements = options.fetch(:skip_soap_elements, false)
    end

    def to_h
      return @memo.to_h unless @skip_soap_elements

      @memo.to_h.values.first&.values&.last
    end

    def attr(name, str)
      return if @delete_namespace_attributes

      return if name == :version
      return if name == :encoding

      start_element("@#{name}")
      text(str)
      end_element(name)
    end

    def start_element(name)
      @arr.push(@memo)

      if @strip_namespaces && name.start_with?('@')
        @name = name.to_sym
      elsif @strip_namespaces
        @name = @map[name] ||= Utils.snakecase(name).split(':').last.to_sym
      else
        @name = @map[name] ||= Utils.snakecase(name).to_sym
      end

      @memo = {}
      text(@memo)
    end

    def end_element(_name)
      @memo = @arr.pop
    end

    def text(value)
      if @arr.last[@name].is_a?(Array)
        @arr.last[@name].pop unless value == @memo
        @arr.last[@name] << cast(value)
      elsif @arr.last[@name] && value == @memo
        @arr.last[@name] = [@arr.last[@name], value]
      else
        @arr.last[@name] = cast(value)
      end
    end

    private

    def cast(value)
      return value unless @advanced_typecasting

      case value
      when EMPTY_STR then nil
      when TRUE_STR then true
      when FALSE_STR then false
      when DATE_TIME then DateTime.parse(value)
      when DATE then Date.parse(value)
      when TIME then Time.parse(value)
      else value
      end
    end
  end
end
