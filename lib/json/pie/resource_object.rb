require "active_support/all"
require_relative "./resource_identity"

module JSON
  module Pie
    class ResourceObject
      attr_reader :instance

      def self.parse(data)
        new(data).tap { |i| i.parse }.instance
      end

      def initialize(data)
        @data = data
      end

      def parse
        extract_instance!
        assign_attributes!
      end

      private

        attr_reader :data

        def extract_instance!
          @instance ||= JSON::Pie::ResourceIdentity.find_or_initialize(**data.slice(:id, :type))
        end

        def assign_attributes!
          instance.attributes = data.fetch :attributes, {}
        rescue ActiveModel::UnknownAttributeError
          raise JSON::Pie::InvalidAttribute
        end
    end
  end
end
