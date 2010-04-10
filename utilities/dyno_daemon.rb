#!/usr/bin/env ruby
require 'rubygems'
require 'daemons'
require 'passenger_dyno'


daemon_options = {
  :multiple   => false,
  :dir_mode   => :normal,
  :dir        => '/var/run/pids',
  :backtrace  => true
}

dyno = DynoCheck.new
 
Daemons.run_proc('passenger_dyno_runner', daemon_options) do
  dyno.run
  sleep(60)
end