# frozen_string_literal: true

require "active_support/all"
require_relative "./resource_object"

module JSON
  module Pie
    class ResourceRelationships
      attr_reader :instance

      def self.assign(**kwargs)
        new(**kwargs).assign
      end

      def initialize(instance:, relationships: {})
        @instance = instance
        @relationships = relationships
      end

      def assign
        relationships.each do |rel, data|
          relationship_instance = ResourceObject.parse (data || {}).fetch(:data, {})
          instance.public_send "#{rel}=", relationship_instance
        end
      end

      private

      attr_reader :relationships
    end
  end
end
