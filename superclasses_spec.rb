require 'rspec'
require File.join(File.dirname(__FILE__), 'superclasses.rb')

describe Object do
  it 'should respond to #superclasses' do
    Object.should respond_to(:superclasses)
  end

  describe '#superclasses' do
    before do
      class Foo;end
      class Bar<Foo;end
      class Baz<Bar;end
    end
    it 'should list all classes in the inhertance chain' do
      Foo.superclasses.should include(Object)
      Bar.superclasses.should include(Foo, Object)
      Baz.superclasses.should include(Bar, Foo, Object)
    end
  end
end

