describe Rover do
  before do
    @rover = Rover.new
    @terrain = Terrain.new(:x => 2, :y => 2)
  end

  describe '#land!' do
    it 'should have ground under its feet' do
      @rover.land!(:terrain => @terrain)
      @rover.terrain.should be_an_instance_of(Terrain)
    end

    it 'should break if landing on an invalid position' do
      @rover.land!(:x => 3, :y => 4, :heading => :n, :terrain => @terrain).should be_false
    end
  end

  describe '#position' do
    it 'should be at its default position if none given' do
      @rover.land!(:terrain => @terrain)
      @rover.position.should == {:x => 0, :y => 0, :heading => :n}
    end
  end

  describe '#position_within_boundaries?' do
    before do
      @rover = Rover.new
    end

    it 'should be true for 0 0' do
      @rover.land!(:terrain => @terrain)
      @rover.send(:position_within_boundaries?).should be_true
    end
  end

  describe '#m!' do
    it 'should not move until landed' do
      @rover.m!.should be_nil
    end

    it 'should move north if it looks north' do
      @rover.land!(:terrain => @terrain)
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :n}).to( {:x => 0, :y => 1, :heading => :n})
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 0, :y => 1, :heading => :n}).to( {:x => 0, :y => 2, :heading => :n})
    end

    it 'should move east if it looks east' do
      @rover.land!(:heading => :e, :terrain => @terrain)
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :e}).to( {:x => 1, :y => 0, :heading => :e})
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 1, :y => 0, :heading => :e}).to( {:x => 2, :y => 0, :heading => :e})
    end

    it 'should move south if it looks south' do
      @rover.land!(:x => 2, :y => 2, :heading => :s, :terrain => @terrain)
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 2, :y => 2, :heading => :s}).to( {:x => 2, :y => 1, :heading => :s})
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 2, :y => 1, :heading => :s}).to( {:x => 2, :y => 0, :heading => :s})
    end

    it 'should move west if it looks west' do
      @rover.land!(:x => 2, :y => 2, :heading => :w, :terrain => @terrain)
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 2, :y => 2, :heading => :w}).to( {:x => 1, :y => 2, :heading => :w})
      lambda {@rover.m!}.should change(@rover, :position).from( {:x => 1, :y => 2, :heading => :w}).to( {:x => 0, :y => 2, :heading => :w})
    end
  end

  describe '#r!' do
    it 'should not move until landed' do
      @rover.m!.should be_nil
    end

    it 'should turn clockwise' do
      @rover.land!(:terrain => @terrain)
      lambda {@rover.r!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :n}).to( {:x => 0, :y => 0, :heading => :e})
      lambda {@rover.r!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :e}).to( {:x => 0, :y => 0, :heading => :s})
      lambda {@rover.r!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :s}).to( {:x => 0, :y => 0, :heading => :w})
      lambda {@rover.r!}.should change(@rover, :position).from( {:x => 0, :y => 0, :heading => :w}).to( {:x => 0, :y => 0, :heading => :n})
    end
  end

  describe '#l!' do
    it 'should call r! 3 times' do
      @rover.should_receive(:r!).exactly(3).times
      @rover.l!
    end
  end
end

