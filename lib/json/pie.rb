# frozen_string_literal: true

require_relative "pie/version"
require_relative "pie/top_level"

module JSON
  module Pie
    Error = Class.new StandardError

    module_function

    def parse(params)
      JSON::Pie::TopLevel.parse params
    end
  end
end
