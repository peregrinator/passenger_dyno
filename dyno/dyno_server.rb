class DynoServer < MongoStore
  many :dyno_server_checks
  
  key :name, String
end