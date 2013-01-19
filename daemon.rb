require 'bundler/setup'

require "sys/cpu"
require 'daemons'

require 'socket'
require 'json'

class Tracker
  def initialize(host_and_port)
    @host, @port = host_and_port.split(':')
    @socket = UDPSocket.new
  end
  
  def track(event_type, data = {})
    msg = {
      type: event_type,
      time: Time.now.to_s,
      data: data
    }
    @socket.send(JSON.dump(msg), 0, @host, @port)
  end
end

def every_n_seconds(n)
  loop do
    before = Time.now
    yield
    interval = n-(Time.now-before)
    sleep(interval) if interval > 0
  end
end

Daemons.run_proc('bootic_server_stats') do
  host_and_port = ENV['DATAGRAM_IO_UDP_HOST']
  tracker = Tracker.new(host_and_port)
  hostname = `hostname`.chomp
  puts "#{Time.now.to_s} Tracking load avg for '#{hostname}' to #{host_and_port}"
  every_n_seconds(15) do
    
    tracker.track('load_avg', {
      :app      => 'server_stats',
      :status   => Sys::CPU.load_avg.first / Sys::CPU.num_cpu.to_f,
      :account  => hostname
    })
  end
end