#######################################################################
# example_sys_cpu_linux.rb
#
# Sample cript for general futzing. You should run this code via the
# 'rake example' task.
#
# Modify as you see fit.
#######################################################################
require 'bundler/setup'

require "sys/cpu"
require "pp"

puts "VERSION: " + Sys::CPU::VERSION
puts "========"

puts "Load Average: " + Sys::CPU.load_avg.join(", ")

puts "Processor Info:"
puts "==============="
pp Sys::CPU.num_cpu.to_s

puts "CPU STATS:"
puts "=========:"

pp Sys::CPU.cpu_stats