module Transposon
  class Client
    attr_reader :schema, :query_str

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

      @parsed_schema = Parser.new(@schema).parse

      @query_str = []
      Generator.generate_methods(self, @parsed_schema)
    end

    def build
      @query_str << '}' * @query_str.size
      @query_str.join(' ')
    end

    def query_str=(new_val)
      @query_str = new_val
    end

    private def subset?(a, b)
      a.all? {|x| b.include? x}
    end
  end
end
