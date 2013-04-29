# -*- coding: utf-8 -*-

require_relative 'lib/shortcut.rb'
require_relative 'lib/rule.rb'
require_relative 'lib/machine.rb'

require 'optparse'

machine = TuringMachine.new
options = {}

$opts = OptionParser.new
$opts.banner = "Usage: emulator.rb [options] rules.mt"

def print_error(message)
  puts message
  puts
  puts $opts
  exit
end

$opts.on("-v", "--verbose", "print intermediate machine states") do
  machine.verbose = true
end

$opts.on("-s", "--single [TAPE]", "run machine on a single tape") do |t|
  options[:tape] = t
end

$opts.on("-m", "--multi [FILENAME]", "run machine on multiple tapes from the file") do |f|
  options[:filename] = f
end

$opts.on("-e", "--empty-char [CHARACTER]", "set character denoting empty tape cell") do |e|
  if e.length != 1
    print_error "Invalid value for empty character" if e.length != 1
  else
    machine.empty_char = e
  end
end

$opts.on_tail("-h", "--help", "show help") do
  puts $opts
  exit
end

$opts.parse!

if ARGV.length == 0
  print_error "Provide location of file with rules"
end

if options[:filename] and options[:tape] then
  print_error "Use either --single or --multi option, not both!"
end

if options[:filename].nil? and options[:tape].nil? then
  print_error "Use at least one of --single or --multi options"
end

begin
  machine.load_from_file ARGV[0]

  if options[:tape]
    puts machine.run_on(options[:tape])
  elsif options[:filename]
    File.open(options[:filename]).each do |line|
      tape = line.strip
      next if tape.empty?
      puts machine.run_on(tape)
    end
  end
rescue Exception => e
  puts "Error! #{e}"
  exit
end
