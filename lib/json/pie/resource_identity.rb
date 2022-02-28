module JSON
  module Pie
    class ResourceIdentity
      attr_reader :instance

      def self.find_or_initialize(**kwargs)
        new(**kwargs).instance
      rescue ArgumentError
        raise JSON::Pie::MissingType
      end

      def initialize(type:, id: nil)
        klass = type.to_s.classify.constantize
        @instance = id ? klass.find(id) : klass.new
      rescue NameError
        raise JSON::Pie::InvalidType
      end
    end
  end
end
