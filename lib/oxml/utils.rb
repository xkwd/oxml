# frozen_string_literal: true

module OXML
  module Utils
    @snakecase_cache = {}
    @camelize_cache = {}

    module_function

    def snakecase(input)
      return input unless input.is_a?(String)

      @snakecase_cache[input] ||= input
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end

    def camelize(input)
      return '' if input.nil?

      input_str = input.to_s
      @camelize_cache[input_str] ||= input_str
        .gsub(/(?:^|_+)([^_])/) { Regexp.last_match(1).upcase }
        .tap { |s| s[0] = s[0].downcase if s.length > 0 }
    end
  end
end
