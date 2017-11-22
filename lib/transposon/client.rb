module Transposon
  class Client
    attr_reader :schema

    def initialize(options)
      options = Transposon::Configuration::DEFAULTS.merge(options)

      filename = options[:filename]
      schema = options[:schema]

      if !filename.nil? && !schema.nil?
        raise ArgumentError, 'Pass in `filename` or `schema`, but not both!'
      end

      if filename.nil? && schema.nil?
        raise ArgumentError, 'Pass in either `filename` or `schema`'
      end

      if filename
        unless filename.is_a?(String)
          raise TypeError, "Expected `String`, got `#{filename.class}`"
        end

        unless File.exist?(filename)
          raise ArgumentError, "#{filename} does not exist!"
        end

        @schema = File.read(filename)
      else
        unless schema.is_a?(String)
          raise TypeError, "Expected `String`, got `#{schema.class}`"
        end

        @schema = schema
      end
    end
  end
end
