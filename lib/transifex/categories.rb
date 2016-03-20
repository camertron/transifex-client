require 'json'

module Transifex
  class Categories
    class << self
      def load(categories)
        case categories
          when Hash then load_hash(categories)
          when Array then load_arr(categories)
          when String then load_str(categories)
          when NilClass then load_nil
          when self then categories
          else
            raise TypeError,
              "Object of type '#{categories.class}' can't be loaded as a "\
              "category set"
        end
      end

      def deserialize(categories_arr)
        categories_arr.each_with_object({}) do |category_str, ret|
          split(category_str).each do |category|
            if idx = category.index(':')
              ret[category[0...idx]] = category[(idx + 1)..-1]
            end
          end
        end
      end

      def serialize(categories_hash)
        categories_hash.map do |key, value|
          "#{key}:#{escape(value)}"
        end
      end

      def escape(str)
        str.gsub(' ', '_')
      end

      def join(arr)
        arr.join(' ')
      end

      def split(str)
        str.split(' ')
      end

      private

      def load_hash(categories)
        new(categories)
      end

      def load_arr(categories)
        new(deserialize(categories))
      end

      def load_str(categories)
        new(deserialize(split(categories)))
      end

      def load_nil
        new({})
      end
    end

    attr_reader :categories

    def initialize(categories)
      @categories = categories
    end

    def to_h
      categories.dup
    end

    def to_a
      self.class.serialize(categories)
    end

    def to_s
      self.class.join(to_a)
    end

    def to_json(*args)
      to_h.to_json(*args)
    end

    def empty?
      categories.empty?
    end

    def [](key)
      categories[key]
    end
  end
end
