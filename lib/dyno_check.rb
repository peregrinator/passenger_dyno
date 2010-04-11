require 'erb'
require 'mongo'
require 'mongo_mapper'

class DynoCheck
  
  def initialize(options={})
    config_path     = options.delete(:config_path) || '/opt/dyno'
    dyno_config     = YAML::load(ERB.new(IO.read(File.join(config_path, 'config.yml'))).result)['dyno']
    database_config = YAML::load(ERB.new(IO.read(File.join(config_path, 'database.yml'))).result)['mongo']
    
    MongoMapper.connection = Mongo::Connection.new(database_config['host'], database_config['port'])
    MongoMapper.database   = database_config['database']
    
    @servers                       = dyno_config['servers']
    @passenger_memory_stats_output = `sudo passenger-memory-stats`
    @passenger_status_output       = `sudo passenger-status`
  end
  
  def run
    @servers.each do |server_name|
      dyno_server = DynoServer.find_by_name(server_name)
      if dyno_server.nil?
        dyno_server = DynoServer.new(:name => server_name)
      end
      
      @current_time = Time.now
      @dyno_server_check = DynoServerCheck.create(:checked_at => @current_time)
      
      overview_check
      thread_check
      
      dyno_server.dyno_server_checks << @dyno_server_check
      dyno_server.save
    end
  end
  
  def overview_check
    # prints 6 lines
    # Line 1 Total Apache worker processes
    # Line 2 Total memory used by Apache worker processes
    # Line 3 Total Nginx worker processes
    # Line 4 Total memory used by Nginx worker processes
    # Line 5 Total Passenger rails processes
    # Line 6 Total memory used by Passenger rails processes
    overview_stats = `echo "#{@passenger_memory_stats_output}" | grep '###' | awk '{print $3"\t"$6}'`.split("\n")
    
    apache_workers_count = overview_stats[0].split("\t")[0]
    apache_memory_used   = overview_stats[1].split("\t")[1]
    
    # here we really only want the passenger processes for our server (minus application and spawn server)
    passenger_process_count = `echo "#{@passenger_memory_stats_output}" | grep 'Rails:' | grep 'govpulse'`.split("\n").length

    passenger_memory_used   = overview_stats[5].split("\t")[1]
    
    # here we really only want the total mem for the threads for our server
    memory_threads = `echo "#{@passenger_memory_stats_output}" | grep 'MB.*Rails' | awk '{ print $1"\t"$4"\t"$7 }' | sort`.split("\n")
    passenger_memory_used_for_server = []
    memory_threads.length.times do |i|
      memory_thread = memory_threads[i].split("\t")
      passenger_memory_used_for_server = passenger_memory_used_for_server + memory_thread[1]
    end
    
    
    @dyno_server_check.passenger_overview = PassengerOverview.new(:total_apache_processes            => apache_workers_count,
                                                                  :total_apache_memory               => apache_memory_used,
                                                                  :total_passenger_processes         => passenger_process_count,
                                                                  :total_passenger_memory            => passenger_memory_used,
                                                                  :total_passenger_memory_for_server => passenger_memory_used_for_server)
  end
  
  def thread_check
    # prints PID PrivateMem ProcessName
    memory_threads = `echo "#{@passenger_memory_stats_output}" | grep 'MB.*Rails' | awk '{ print $1"\t"$4"\t"$7 }' | sort`.split("\n")
    
    # prints PID Sessions Processed Uptime(min) Uptime(sec) seperated by tabs
    status_threads = `echo "#{@passenger_status_output}" | grep 'PID: ' | awk '{ print $2"\t"$4"\t"$6"\t"$8"\t"$9 }' | sort`.split("\n")
    
    memory_threads.length.times do |i|
      memory_thread = memory_threads[i].split("\t")
      pid           = memory_thread[0]
      private_mem   = memory_thread[1]
      process_name  = memory_thread[2]
      
      status_thread      = status_threads[i].split("\t")
      sessions_waiting   = status_thread[1]
      sessions_processed = status_thread[2]
      uptime             = (status_thread[3].slice(0...-1) * 60) + status_thread[4].slice(0...-1)
      
      @dyno_server_check.passenger_threads << PassengerThread.new(:pid                => pid,
                                                                  :private_mem        => private_mem,
                                                                  :process_name       => process_name,
                                                                  :sessions_waiting   => sessions_waiting,
                                                                  :sessions_processed => sessions_processed,
                                                                  :uptime             => uptime)
    end
    
  end
end