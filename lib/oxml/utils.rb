# frozen_string_literal: true

module OXML
  module Utils
    module_function

    def snakecase(input)
      return input unless input.is_a?(String)

      input
        .gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
        .gsub(/([a-z\d])([A-Z])/, '\1_\2')
        .tr('-', '_')
        .downcase
    end

    def camelize(input)
      return '' if input.nil?

      input_str = input.to_s
      input_str
        .gsub(/(?:^|_+)([^_])/) { Regexp.last_match(1).upcase }
        .tap { |s| s[0] = s[0].downcase if s.length.positive? }
    end
  end
end
