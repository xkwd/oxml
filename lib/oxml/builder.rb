# frozen_string_literal: true

module OXML
  class Builder
    def initialize(hash)
      @hash = hash
      @builder = Ox::Builder.new(indent: -1)
    end

    def to_s
      traverse_hash(@hash, @builder)
      @builder.close
      @builder.to_s
    end

    private

    def traverse_hash(hash, builder)
      hash.each do |key, value|
        if value.is_a?(Hash) && !key.to_s.start_with?('@')
          attributes = value.keys.select { |k| k.to_s.start_with?('@') }
          if attributes.any?
            mapped_attributes = attributes.each_with_object({}) do |attr, memo|
              memo[attr[1..]] = value[attr].to_s
              value.delete(attr)
            end
            builder.element(key, mapped_attributes)

          else
            builder.element(key)
          end
          traverse_hash(value, builder)
          builder.pop
        elsif value.is_a?(Array)
          traverse_array(key, value, builder)
        elsif value.nil?
          builder.element(key, 'xsi:nil': 'true')
        else
          builder.element(key)
          builder.text(value)
          builder.pop
        end
      end
    end

    def traverse_array(key, array, builder)
      array.each do |array_el|
        if array_el.is_a?(Hash)
          traverse_hash({ key => array_el }, builder)
        else
          builder.element(key)
          builder.text(array_el)
          builder.pop
        end
      end
    end
  end
end
