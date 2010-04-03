class PassengerThread < MongoStore
  key :dyno_server_check_id, ObjectId
  
  key :pid,                Integer
  key :private_mem,        Integer
  key :process_name,       Integer
  key :sessions_waiting,   Integer
  key :sessions_processed, Integer
  key :uptime,             Integer
end