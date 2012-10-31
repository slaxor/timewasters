#!/usr/bin/env ruby
$: << '.'
require 'debugger'
require 'logger'
Signal.trap('EXIT') do
  puts 'Don`t leave us alone up there, it`s dry and the air is so thin ;('
  exit(0)
end

$logger = Logger.new(File.join('log', 'rover.log'))
Dir.glob(File.join('app', '*.rb')).each {|f| require f}
Repl.new

