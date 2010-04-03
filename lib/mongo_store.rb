require 'rubygems'
require 'mongo'
require 'mongo_mapper'

class MongoStore
  include MongoMapper::Document
  set_database_name 'passenger_dyno'
end