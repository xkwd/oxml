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
      @last_attr = nil
      @strip_namespaces = options.fetch(:strip_namespaces, false)
      @delete_namespace_attributes = options.fetch(:delete_namespace_attributes, false)
      @advanced_typecasting = options.fetch(:advanced_typecasting, false)
      @skip_soap_elements = options.fetch(:skip_soap_elements, false)
      @symbolize_keys = options.fetch(:symbolize_keys, true)
      @strip_whitespace = options.fetch(:strip_whitespace, false)
      @normalize_whitespace = options.fetch(:normalize_whitespace, false)
      @force_utf8 = options.fetch(:force_utf8, false)
    end

    def to_h
      return @memo.to_h unless @skip_soap_elements

      @memo.to_h.values.first&.values&.last
    end

    def attr(name, str)
      str = normalize_encoding(str)
      @last_attr = "#{name}:#{str}"
      return if @delete_namespace_attributes

      return if name == :version
      return if name == :encoding

      start_element("@#{name}")
      text(str)
      end_element(name)
    end

    def start_element(name)
      name = name.to_s
      @arr.push(@memo)

      if @strip_namespaces && name.start_with?('@')
        @name = @symbolize_keys ? name.to_sym : name
      else
        processed_name = Utils.snakecase(name)
        processed_name = processed_name.split(':').last if @strip_namespaces
        @name = @map[name] ||= (@symbolize_keys ? processed_name.to_sym : processed_name)
      end

      @memo = {}
      text(@memo)
    end

    def attrs_done
      if @last_attr =~ /nil:true/
        @last_attr = nil
        @arr.last[@name] = nil
      end
    end

    def end_element(_name)
      @memo = @arr.pop
    end

    def text(value)
      value = normalize_encoding(value)
      # Apply whitespace optimizations only when explicitly enabled
      if @strip_whitespace && value.is_a?(String)
        value = value.strip
      end

      if @normalize_whitespace && value.is_a?(String)
        value = value.gsub(/\s+/, ' ').strip
      end

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

    def normalize_encoding(value)
      return value unless @force_utf8 && value.is_a?(String)

      value.dup.force_encoding('UTF-8')
    end

    def cast(value)
      return if value == EMPTY_STR
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
