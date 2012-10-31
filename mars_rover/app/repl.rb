class Repl
  def initialize
    catch :exit do
      print_welcome
      set_terrain
      loop do
        next unless set_landing_point
        read_movement_commands
        show_position
      end
    end
  end

  def print_welcome
    puts "Welcome to the RoverCLI\nType 'X' alone on a line to end\n\n"

  end

  def set_terrain
    valid = false
    while not valid
      print ' What is the size of this terrain? ("<x> <y>"): '
      get_input.chomp.match(/^(\d+)\s*(\d+)/)
      valid = ($1 && $2)
    end
    @terrain = Terrain.new(:x => $1.to_i, :y => $2.to_i)
  end

  def set_landing_point
    @rover = Rover.new
    print 'Where do you wish to land? ("[0 0] [N]"): '
    get_input.chomp.downcase.match(/^(\d+) (\d+) ?([nesw]?)$/)

    landed = if !$3.to_s.empty?
      @rover.land!(:x => $1.to_i, :y => $2.to_i, :heading => $3.to_sym, :terrain => @terrain)
    elsif $1 && $2
      @rover.land!(:x => $1.to_i, :y => $2.to_i, :terrain => @terrain)
    else
      @rover.land!(:terrain => @terrain)
    end
    if landed
      puts "\n\nok the rover has landed at #{@rover.position}"
    else
      puts "\n\nBoom!"
    end
    landed
  end

  def read_movement_commands
    print 'ready to move [MLR] > '
    cmds = get_input.chomp.upcase.match(/^([MLR]*)$/)[1].split('')
    if cmds
      cmds.each do |cmd|
       @rover.send({'M' => :m!, 'L' => :l!, 'R' => :r!}[cmd])
      end
    else
      puts 'command not understood'
    end
  end

  def show_position
    puts @rover.position.values.join(' ').upcase
  end

  private
  def get_input
    input = gets.chomp
    throw :exit if input.downcase.match(/^x$/)
    input
  end
end

