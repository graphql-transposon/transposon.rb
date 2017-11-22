require 'graphql'

module Transposon
  class Parser
    def initialize(schema)
      @schema = GraphQL::Schema.from_definition(schema)
      @processed_schema = {
        operations: {},
        mutation_types: [],
        object_types: [],
        interface_types: [],
        enum_types: [],
        union_types: [],
        input_object_types: [],
        scalar_types: [],
      }
    end

    def parse
      unless @schema.types['Query'].nil?
        @processed_schema[:operations][:query] = {}
      end

      if @processed_schema[:operations][:query]
        @schema.types['Query'].fields.each_pair do |name, field|
          args = []
          field.arguments.each_pair do |arg_name, arg|
            h = { }
            h[arg_name.to_sym] = {
              required: arg.type.non_null?
            }
            args << h
          end
          @processed_schema[:operations][:query][name.to_sym] = { arguments: args }
        end
      end

      @schema.types.each_value do |object|
        data = {}

        # case object
        # when ::GraphQL::ObjectType
        #   if object.name == 'Query'
        #     data[:name] = object.name
        #     data[:description] = object.description
        #
        #     data[:interfaces] = object.interfaces.map(&:name).sort
        #     data[:fields], data[:connections] = fetch_fields(object.fields)
        #
        #     @processed_schema[:operation_types] << data
        #   elsif object.name == 'Mutation'
        #       data[:name] = object.name
        #       data[:description] = object.description
        #
        #       @processed_schema[:operation_types] << data
        #
        #       object.fields.each_value do |mutation|
        #         h = {}
        #         h[:name] = mutation.name
        #         h[:description] = mutation.description
        #         h[:input_fields], _ = fetch_fields(mutation.arguments.values.first.type.unwrap.input_fields)
        #         h[:return_fields], _ = fetch_fields(mutation.type.unwrap.fields)
        #
        #         @processed_schema[:mutation_types] << h
        #       end
        #   else
        #     data[:name] = object.name
        #     data[:description] = object.description
        #
        #     data[:interfaces] = object.interfaces.map(&:name).sort
        #     data[:fields], data[:connections] = fetch_fields(object.fields)
        #
        #     @processed_schema[:object_types] << data
        #   end
        # when ::GraphQL::InterfaceType
        #   data[:name] = object.name
        #   data[:description] = object.description
        #   data[:fields], data[:connections] = fetch_fields(object.fields)
        #
        #   @processed_schema[:interface_types] << data
        # when ::GraphQL::EnumType
        #   data[:name] = object.name
        #   data[:description] = object.description
        #
        #   data[:values] = object.values.values.map do |val|
        #     h = {}
        #     h[:name] = val.name
        #     h[:description] = val.description
        #     unless val.deprecation_reason.nil?
        #       h[:is_deprecated] = true
        #       h[:deprecation_reason] = val.deprecation_reason
        #     end
        #     h
        #   end
        #
        #   @processed_schema[:enum_types] << data
        # when ::GraphQL::UnionType
        #   data[:name] = object.name
        #   data[:description] = object.description
        #   data[:possible_types] = object.possible_types.map(&:name).sort
        #
        #   @processed_schema[:union_types] << data
        # when ::GraphQL::InputObjectType
        #   data[:name] = object.name
        #   data[:description] = object.description
        #
        #   data[:input_fields], _ = fetch_fields(object.input_fields)
        #
        #   @processed_schema[:input_object_types] << data
        # when ::GraphQL::ScalarType
        #   data[:name] = object.name
        #   data[:description] = object.description
        #
        #   @processed_schema[:scalar_types] << data
        # else
        #   raise TypeError, "I'm not sure what #{object.class} is!"
        # end
      end

      # @processed_schema[:mutation_types].sort_by! { |o| o[:name] }
      # @processed_schema[:object_types].sort_by! { |o| o[:name] }
      # @processed_schema[:interface_types].sort_by! { |o| o[:name] }
      # @processed_schema[:enum_types].sort_by! { |o| o[:name] }
      # @processed_schema[:union_types].sort_by! { |o| o[:name] }
      # @processed_schema[:input_object_types].sort_by! { |o| o[:name] }
      # @processed_schema[:scalar_types].sort_by! { |o| o[:name] }
      #
      # @processed_schema[:interface_types].each do |interface|
      #   interface[:implemented_by] = []
      #   @processed_schema[:object_types].each do |obj|
      #     if obj[:interfaces].include?(interface[:name])
      #       interface[:implemented_by] << obj[:name]
      #     end
      #   end
      # end

      @processed_schema.to_dot
    end

    private

    # def fetch_fields(object_fields)
    #   fields = []
    #   connections = []
    #
    #   object_fields.each_value do |field|
    #     hash = {}
    #
    #     hash[:name] = field.name
    #     hash[:description] = field.description
    #     if field.respond_to?(:deprecation_reason) && !field.deprecation_reason.nil?
    #       hash[:is_deprecated] = true
    #       hash[:deprecation_reason] = field.deprecation_reason
    #     end
    #
    #     hash[:type] = generate_type(field.type)
    #
    #     hash[:arguments] = []
    #     if field.respond_to?(:arguments)
    #       field.arguments.each_value do |arg|
    #         h = {}
    #         h[:name] = arg.name
    #         h[:description] = arg.description
    #         h[:type] = generate_type(arg.type)
    #
    #         hash[:arguments] << h
    #       end
    #     end
    #
    #     if !argument?(field) && field.connection?
    #       connections << hash
    #     else
    #       fields << hash
    #     end
    #   end
    #
    #   [fields, connections]
    # end
    #
    # def argument?(field)
    #   field.is_a?(::GraphQL::Argument)
    # end
  end
end
