require "active_support/all"
require_relative "./resource_identity"
require_relative "./resource_relationships"

module JSON
  module Pie
    class ResourceObject
      attr_reader :instance

      def self.parse(data, **options)
        new(data, **options).tap { |i| i.parse }.instance
      end

      def initialize(data, **options)
        @data = data
        @options = options
      end

      def parse
        case data
        when Hash then parse_as_object
        when Array then parse_as_array
        end
      end

      private

        attr_reader :data, :options

        def parse_as_object
          extract_instance!
          assign_attributes!
          assign_relationships!
        end

        def parse_as_array
          @instance = data.collect { |d| ResourceObject.parse(d, **options) }
        end

        def extract_instance!
          @instance ||= JSON::Pie::ResourceIdentity.find_or_initialize(**data.slice(:id, :type), **options)
        end

        def assign_attributes!
          instance.attributes = data.fetch :attributes, {}
        rescue ActiveModel::UnknownAttributeError
          raise JSON::Pie::InvalidAttribute
        end

        def assign_relationships!
          JSON::Pie::ResourceRelationships.assign \
            instance: instance,
            relationships: data.fetch(:relationships, {})
        end
    end
  end
end
