require "active_support/all"

module JSON
  module Pie
    class ResourceObject
      attr_reader :instance

      def self.parse(data)
        new(data).tap { |i| i.parse }.instance
      end

      def initialize(data)
        @id = data.fetch(:id, nil)
        @type = data.fetch(:type)
      end

      def parse
        klass = type.to_s.classify.constantize
        @instance = id ? klass.find(id) : klass.new
      end

      private

        attr_reader :id, :type
    end
  end
end
