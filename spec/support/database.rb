# frozen_string_literal: true

require "active_record"
require "erb"
require "fileutils"
require "logger"
require "yaml"

module Database
  module_function

  DATABASE_PATH = File.expand_path("database.yml", __dir__)

  def load_schema
    require File.expand_path("../data/schema", __dir__)
  end

  def connect
    ::ActiveRecord::Base.establish_connection config["sqlite3"]
    ::ActiveRecord::Migration.verbose = false
    load_schema
    ::ActiveRecord::Schema.migrate :up
  end

  def config
    @config ||= YAML.safe_load(ERB.new(File.read(DATABASE_PATH)).result)
  end
end
