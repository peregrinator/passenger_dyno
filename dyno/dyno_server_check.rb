class DynoServerCheck < MongoStore
  one  :passenger_overview
  many :passenger_threads
  
  key :dyno_server_id, ObjectId
  key :checked_at, Time
end