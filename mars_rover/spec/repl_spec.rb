class Repl
  def loop
    yield
  end
end

describe Repl do
  describe '#initialize' do
    it 'should call print_welcome' do
      Repl.any_instance.should_receive(:print_welcome)
      Repl.any_instance.should_receive(:set_terrain)
      Repl.any_instance.should_receive(:set_landing_point)
      #Repl.any_instance.should_receive(:read_movement_commands)
      #Repl.any_instance.should_receive(:show_position)
      StdIOFaker.with_fake_input("5 5\n", "1 2 N\n", "MMMM\n", "X\n") do
        Repl.new rescue nil
      end
    end
  end

  describe '#set_terrain' do
    it 'should should set the terrain dimension' do
      Repl.any_instance.stub(:initialize).and_return(lambda {self})
      Repl.any_instance.should_receive(:get_input).and_return("5 5")
      @repl = Repl.new
      @repl.set_terrain
      @repl.instance_variable_get(:@terrain).dimension.should == {:x => 5, :y => 5}
    end
  end

  describe '#set_landing_point' do
    it 'should set the landing point' do
      Repl.any_instance.stub(:initialize).and_return(lambda {self})
      Repl.any_instance.should_receive(:get_input).and_return("2 2 E")
      @repl = Repl.new
      @repl.set_landing_point.should be_true
      @repl.instance_variable_get(:@rover).position.should == {:x => 2, :y => 2, :heading => :e}
    end
  end

  describe '#read_movement_commands' do
    it 'should move the rover' do
      Repl.any_instance.stub(:initialize).and_return(lambda {self})
      Repl.any_instance.should_receive(:get_input).and_return("2 2 E")
      Repl.any_instance.should_receive(:get_input).and_return("MMRMM")
      @repl = Repl.new
      @repl.set_landing_point
      @repl.read_movement_commands
      @repl.instance_variable_get(:@rover).position.should == {:x => 2, :y => 2, :heading => :s}
    end
  end
end

