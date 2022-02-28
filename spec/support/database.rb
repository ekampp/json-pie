require 'active_record'
require 'erb'
require 'fileutils'
require 'logger'
require 'yaml'

module Database
  extend self

  DATABASE_PATH = File.expand_path('../database.yml', __FILE__)

  def load_schema
    require File.expand_path('../../data/schema', __FILE__)
  end

  def connect
    ::ActiveRecord::Base.establish_connection config["sqlite3"]
    ::ActiveRecord::Migration.verbose = false
    load_schema
    ::ActiveRecord::Schema.migrate :up
  end

  def config
    @config ||= YAML::load(ERB.new(File.read(DATABASE_PATH)).result)
  end
end
