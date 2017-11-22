module Transposon
  module Generator
    class << self
      def generate_methods(client, schema)
        if schema[:operations].key?(:query)
          client.define_singleton_method(:query) do
            client.query_str = [] unless client.query_str.empty?
            client.query_str << 'query {'
            self
          end

          schema[:operations][:query].each_pair do |name, property|
            all_arguments = property[:arguments].map { |arg| arg.keys }.flatten
            unrequired_args = []
            required_args = []

            property[:arguments].each do |argument|
              argument.each_pair do |name, values|
                if values[:required]
                  required_args << name
                else
                  unrequired_args << name
                end
              end
            end

            client.define_singleton_method(name) do |**kwargs|
              provided_args = kwargs.keys
              total_args = (provided_args - all_arguments)

              unless total_args.empty?
                raise ArgumentError, "Expected args to match just #{all_arguments}, but you also provided #{total_args}"
              end

              unless subset?(required_args, kwargs.keys)
                raise ArgumentError, "Required args must be all of #{required_args}, but you did not provide them"
              end

              args_string = kwargs.each_with_object([]) do |(name, value), arr|
                if value.is_a?(String)
                  arr << "#{name}: \"#{value}\""
                else
                  arr << "#{name}: #{value}"
                end
              end

              args_string = '(' + args_string.join(', ') + ')'

              client.query_str << "#{name}#{args_string} {"

              self
            end
          end
        end
      end
    end
  end
end
