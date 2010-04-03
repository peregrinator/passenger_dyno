class PassengerOverview < MongoStore
  key :dyno_server_check_id, ObjectId
   
  key :total_apache_processes, Integer
  key :total_apache_memory,    Integer
  
  key :total_passenger_processes, Integer
  key :total_passenger_memory,    Integer 
end