#!/usr/bin/env ruby
# frozen_string_literal: true
require 'httparty'
class Bookapp
  def initialize(query)
    @url = URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{query}")
  end

  def fetch
    @result = HTTParty.get(@url)
  end

  def parse
    @parsed_result = @result.parsed_response['items'].map { |i| i['volumeInfo']['title'] }
  end

  def result
    if @parsed_result
      @parsed_result
    else
      fetch
      parse
    end
  end

  def pretty_result
    result.each_with_index.map do |r, i|
      format('% 5i: %s', i + 1, r)
    end.join("\n")
  end
end

if File.basename(__FILE__) == File.basename($PROGRAM_NAME)
  if ARGV.empty?
    $stderr.puts "query term missing:\n#{__FILE__} <query>"
    exit(1)
  end
  ba = Bookapp.new(ARGV.join(' '))
  puts ba.pretty_result
end

