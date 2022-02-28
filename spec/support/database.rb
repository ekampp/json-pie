require 'active_record'
require 'erb'
require 'fileutils'
require 'logger'
require 'yaml'

module Database
  extend self

  DATABASE_PATH = File.expand_path('../database.yml', __FILE__)

  DEFAULT_STRATEGY = :transaction

  def load_schema
    require File.expand_path('../../data/schema', __FILE__)
  end

  def connect
    ::ActiveRecord::Base.establish_connection config[driver]
    load_schema
    ::ActiveRecord::Schema.migrate :up
  end

  def config
    @config ||= YAML::load(ERB.new(File.read(DATABASE_PATH)).result)
  end

  def driver
    ENV.fetch('DB', 'sqlite3').downcase
  end

  def in_memory?
    config[driver]['database'] == ':memory:'
  end

  def create!
    db_config = config[driver]
    command = case driver
    when "mysql"
      "mysql -u #{db_config['username']} --password=#{db_config['password']} --protocol tcp -e 'create database #{db_config['database']} character set utf8 collate utf8_general_ci;' >/dev/null"
    when "postgres", "postgresql"
      "psql -c 'create database #{db_config['database']};' -U #{db_config['username']} -h localhost >/dev/null"
    end

    puts command
    puts '-' * 72
    %x{#{command || true}}
  end

  def drop!
    db_config = config[driver]
    command = case driver
    when "mysql"
      "mysql -u #{db_config['username']} --password=#{db_config['password']} --protocol tcp -e 'drop database #{db_config["database"]};' >/dev/null"
    when "postgres", "postgresql"
      "psql -c 'drop database #{db_config['database']};' -U #{db_config['username']} -h localhost >/dev/null"
    end

    puts command
    puts '-' * 72
    %x{#{command || true}}
  end

  def migrate!
    return if in_memory?
    ::ActiveRecord::Migration.verbose = true
    connect
    load_schema
    ::ActiveRecord::Schema.migrate :up
  end

  def mysql?
    driver == 'mysql'
  end

  def postgres?
    driver == 'postgresql'
  end

  def sqlite?
    driver == 'sqlite3'
  end

  def native_array_support?
    postgres?
  end

  # PostgreSQL and MySql doen't support table names longer than 63 chars
  def long_table_name_support?
    sqlite?
  end

  def cleaning_strategy(strategy, &block)
    DatabaseCleaner.clean
    DatabaseCleaner.strategy = strategy
    DatabaseCleaner.cleaning(&block)
    DatabaseCleaner.strategy = DEFAULT_STRATEGY
  end
end
