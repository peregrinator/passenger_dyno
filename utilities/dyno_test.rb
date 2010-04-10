require 'rubygems'
require 'daemons'
require 'passenger_dyno'

dyno = DynoCheck.new

2.times do |i|
  puts "Run ##{i}"
  dyno.run
  sleep(60)
end