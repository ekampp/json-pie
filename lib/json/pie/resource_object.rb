require "active_support/all"

module JSON
  module Pie
    class ResourceObject
      attr_reader :instance

      def self.parse(data)
        new(data).tap { |i| i.parse }.instance
      end

      def initialize(data)
        @id = data.fetch :id, nil
        extract_type! data
        @attributes = data.fetch :attributes, {}
        @relationships = data.fetch :relationships, {}
      end

      def parse
        @instance = extract_instance!
        instance.attributes = attributes
      rescue ActiveModel::UnknownAttributeError
        raise JSON::Pie::InvalidAttribute
      end

      private

        attr_reader :id, :type, :attributes, :relationships

        def extract_type!(data)
          @type = data.fetch :type
        rescue KeyError
          raise JSON::Pie::MissingType
        end

        def extract_instance!
          klass = type.to_s.classify.constantize
          @instance = id ? klass.find(id) : klass.new
        rescue NameError
          raise JSON::Pie::InvalidType
        end
    end
  end
end
