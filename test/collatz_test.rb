require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + "/../collatz")
class Fixnum;include Collatz;end
class CollatzTest < Test::Unit::TestCase
  def test_value
    assert_equal [13,40,20,10,5,16,8,4,2,1], 13.collatz
  end
end
