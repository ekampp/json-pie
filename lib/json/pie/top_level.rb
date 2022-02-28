require_relative "./resource_object"

module JSON
  module Pie
    class TopLevel
      attr_accessor :instance

      def self.parse(params)
        new(params).tap { |i| i.parse }.instance
      end

      def initialize(params)
        params = params.permit!.to_h.deep_symbolize_keys if params.respond_to?(:permit!)
        @params = params
      end

      def parse
        data = params.fetch(:data)
        self.instance = case data
        when Array then parse_as_array
        else parse_as_object
        end
      end

      private

        attr_reader :params

        def parse_as_array
          params.fetch(:data).collect do |resurce_object|
            parse_as_object resurce_object
          end
        end

        def parse_as_object(resurce_object = params.fetch(:data))
          JSON::Pie::ResourceObject.parse(resurce_object)
        end
    end
  end
end
