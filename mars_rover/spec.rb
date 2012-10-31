#!/usr/bin/env rspec
#
#
require 'debugger'
require 'logger'
require 'stringio'
$logger = Logger.new(File.join('log', 'rspec.log'))
$: << '.'

class StdIOFaker
  attr_reader :stdout, :stderr
  def initialize(input_strings)
    @input_strings = input_strings
  end

  def gets
    next_string = @input_strings.shift
    STDOUT.puts("I faked input of: #{next_string}")
    next_string
  end


  def self.with_fake_input(*input_strings)
    $stdin = new(input_strings)
    $stdout, $stderr = StringIO.new, StringIO.new
    yield
    $stdout.seek(0)
    $stderr.seek(0)
    {:stdout => $stdout.read, :stderr => $stderr.read}
  ensure
    $stdin = STDIN
    $stdout, $stderr = STDOUT, STDERR
  end
end

Dir.glob(File.join('{app,spec}', '*.rb')).each {|f| require f}

