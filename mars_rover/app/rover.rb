class Rover
  INITIAL_POSITION = {:x => 0, :y => 0, :heading => :n}
  HEADINGS = {:n => {:x => 0, :y => 1}, :e => {:x => 1,:y => 0}, :s => {:x => 0,:y => -1}, :w => {:x => -1,:y => 0}}

  attr_reader :position, :dimension, :terrain

  def land!(pos = {})
    $logger.info("#{self} has already landed") if @terrain
    @terrain = pos.delete(:terrain)
    @position = INITIAL_POSITION.merge(pos)

    unless position_within_boundaries?
      $logger.fatal("Aaaaaaaaaaa,  falling... (#{self} has crashed at position #{@position})")
      false
    else
      $logger.info("#{self} has landed safely at position #{@position}")
      true
    end
  end

  def m!
    unless @terrain
      $logger.warn('The rover has not touched ground yet. Please wait, until it`s landed')
      return
    end
    @position[:x] += HEADINGS[@position[:heading]][:x]
    @position[:y] += HEADINGS[@position[:heading]][:y]

    unless position_within_boundaries?
      $logger.warn('Asimovs 3rd law forbids me to commit suicide')
      @position[:x] -= HEADINGS[@position[:heading]][:x]
      @position[:y] -= HEADINGS[@position[:heading]][:y]
    end
  end

  def r!
    @position[:heading] = HEADINGS.keys[(HEADINGS.keys.index(@position[:heading]) + 1)%4]
  end

  def l!
    r!;r!;r!
  end

  private

  def position_within_boundaries?
    return true unless @terrain #air is patient
    @position[:x] >= 0 && @position[:x] <= @terrain.dimension[:x] &&
       @position[:y] >= 0 && @position[:y] <= @terrain.dimension[:y]
  end
end

