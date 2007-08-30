require File.join(File.dirname(__FILE__), '..', 'test_helper')

class StringTest < Screw::Unit::TestCase
  
  def setup
    @string = %{
      0123456789
      012345
      01234567
      0123
    }.tabto(0).strip
  end
  
  def test_column
    @string.column_of(0).should == 0
    @string.column_of(5).should == 5
    @string.column_of(10).should == 10
    @string.column_of(11).should == 0
    @string.column_of(17).should == 6
    @string.column_of(18).should == 0
    @string.column_of(24).should == 6
  end
end
