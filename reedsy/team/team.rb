# frozen_string_literal: true

class Team
  Member = Struct.new(:name)

  def initialize
    @members = []
  end

  def <<(name)
    @members << Member.new(name)
  end

  def members_names
    @members.map(&:name)
  end

  def pro_print(limit = 10)
    members_names.take(limit).each { |name| puts name.capitalize }
  end

  def reverse_print
    members_names.reverse.each { |name| puts name.reverse.downcase }
  end

  def funny_print
    puts 'Rise and shine'
    sleep(1)
    m = members_names.join(', ')
    no_of_frames = 240
    term_height = ENV['LINES'].to_f
    line_ratio =  term_height / no_of_frames

    no_of_frames.times do |i|
      print "\e[H\e[2J"
      print "\n" * (term_height - i * line_ratio)
      print m
      sleep(1.0 / 12)
    end
  end

  def shuffle_print
    puts "Members:"
    members_names.shuffle.each { |name| puts "* #{name}" }
  end

  def plain_print
    puts "Members:"
    members_names.each { |name| puts "* #{name}" }
  end

  def presentation(how = :shuffle) # or :plain, :funny, :reverse, :pro
    send("#{how}_print")
  end
end

