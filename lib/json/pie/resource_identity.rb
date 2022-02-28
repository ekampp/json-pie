# frozen_string_literal: true

module JSON
  module Pie
    class ResourceIdentity
      attr_reader :instance

      def self.find_or_initialize(type:, id: nil, **options)
        new(type: type, id: id, **options).instance
      rescue ArgumentError
        raise JSON::Pie::MissingType
      end

      def initialize(type:, id: nil, **options)
        @options = options
        klass = determine_type(type).to_s.classify.constantize
        @instance = id ? klass.find(id) : klass.new
      rescue NameError
        pp options
        raise JSON::Pie::InvalidType, "#{type}(#{id})"
      end

      private

      attr_reader :options

      def determine_type(type)
        options.dig(:type_map, type).presence || type
      end
    end
  end
end
