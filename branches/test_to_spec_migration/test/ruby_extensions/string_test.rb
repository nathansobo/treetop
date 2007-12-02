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
  
  test "column numbers" do
    @string.column_of(0).should == 1
    @string.column_of(5).should == 6
    @string.column_of(10).should == 11
    @string.column_of(11).should == 1
    @string.column_of(17).should == 7
    @string.column_of(18).should == 1
    @string.column_of(24).should == 7
  end
  
  test "line numbers" do
    @string.line_of(0).should == 1
    @string.line_of(5).should == 1
    @string.line_of(10).should == 1
    @string.line_of(11).should == 2
    @string.line_of(17).should == 2
    @string.line_of(18).should == 3
    @string.line_of(24).should == 3
  end
end
