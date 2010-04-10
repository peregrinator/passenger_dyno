class DynoCheck
  
  def initialize(options={})
    config_path = options.delete(:config_path) || '/opt/dyno'
    
    @servers                       = YAML::load(ERB.new(IO.read(File.join(config_path, 'config', 'config.yml'))).result)['dyno']
    @passenger_memory_stats_output = `passenger-memory-stats`
    @passenger_status_output       = `passenger-status`
    @dyno_server_check = DynoServerCheck.create(:checked_at => @current_time)
  end
  
  def run
    @current_time = Time.now
    @servers.each do |server_name|
      dyno_server = DynoServer.find_by_name(server_name)
      if dyno_server.nil?
        dyno_server = DynoServer.new(:name => server_name)
      end
      
      overview_check
      thread_check
      
      dyno_server.hopper_server_checks << @dyno_server_check
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
    overview_stats = `grep '###' "#{@passenger_memory_stats_output}" | awk '{print $3"\t"$6}'`.split("\n")
    
    apache_workers    = overview_stats[0].split("\t")[0]
    apache_memory     = overview_stats[1].split("\t")[1]
    passenger_process = overview_stats[4].split("\t")[0]
    passenger_memory  = overview_stats[5].split("\t")[1]
    
    @dyno_server_check.overview = PassengerOverview.new(:total_apache_processes    => apache_workers,
                                                          :total_apache_memory       => apache_memory,
                                                          :total_passenger_processes => passenger_process,
                                                          :total_passenger_memory    => passenger_memory)
  end
  
  def thread_check
    # prints PID PrivateMem ProcessName
    memory_threads = `grep 'MB.*Rails' "#{@passenger_memory_stats_output}" | awk '{ print $1"\t"$4"\t"$7 }'`.split('\n')
    
    # prints PID Sessions Processed Uptime(min) Uptime(sec) seperated by tabs
    status_threads = `grep 'PID: ' "#{@passenger_status_output}" | awk '{ print $2"\t"$4"\t"6"\t"$8"\t"$9 }'`.split('\n')
    
    memory_threads.length.times do |i|
      memory_thread = memory_threads[i-1].split("\t")
      pid           = memory_thread[0]
      private_mem   = memory_thread[1]
      process_name  = memory_thread[2]
      
      status_thread      = status_threads[i-1].split("\t")
      sessions_waiting   = status_thread[1]
      sessions_processed = status_thread[2]
      uptime             = (status_thread[3] * 60) + status_thread[4]
      
      @dyno_server_check.passenger_threads << PassengerThread.new(:pid                => pid,
                                                                  :private_mem        => private_mem,
                                                                  :process_name       => process_name,
                                                                  :sessions_waiting   => sessions_waiting,
                                                                  :sessions_processed => sessions_processed,
                                                                  :uptime             => uptime)
    end
    
  end
end