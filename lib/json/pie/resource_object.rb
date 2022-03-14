# frozen_string_literal: true

require "active_support/all"
require_relative "./resource_identity"
require_relative "./resource_relationships"

module JSON
  module Pie
    class ResourceObject
      def self.parse(data, **options)
        new(data, **options).tap(&:parse).instance
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

      def instance
        return nil if data.blank?

        @instance ||= JSON::Pie::ResourceIdentity.find_or_initialize(**data.slice(:id, :type), **options)
      end

      private

      attr_reader :data, :options

      def parse_as_object
        assign_attributes!
        assign_relationships!
      end

      def parse_as_array
        @instance = data.collect { |d| ResourceObject.parse(d, **options) }
      end

      def assign_attributes!
        instance&.attributes = attributes_tuple.to_h
      rescue ActiveModel::UnknownAttributeError
        raise JSON::Pie::InvalidAttribute
      end

      def assign_relationships!
        JSON::Pie::ResourceRelationships.assign \
          instance: instance,
          relationships: data.fetch(:relationships, {})
      end

      def attributes_tuple
        data.fetch(:attributes, {}).collect do |key, value|
          key = options.dig(:attributes_map, data.fetch(:type), key).presence || key
          [key, value]
        end
      end
    end
  end
end
