# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"

require "rails/all"
require "rspec/its"
require "json/pie"

# Connect in-memory sqlite database
require_relative "./support/database"
Database.connect

# Require models
require_relative "./support/user"
require_relative "./support/article"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
