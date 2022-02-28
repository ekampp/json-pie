require_relative "database"
Database.connect

class User < ActiveRecord::Base
end
