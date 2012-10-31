describe Terrain do
  it 'should have a dimension' do
    Terrain.new(:x => 1, :y => 1).dimension.should_not be_empty
  end
end

