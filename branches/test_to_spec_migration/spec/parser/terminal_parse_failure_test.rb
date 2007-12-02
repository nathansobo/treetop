dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

describe "A terminal parse failure" do
  def setup
    @input = "test input"
    @failure = Runtime::TerminalParseFailure.new(@input, 1, "foo")
  end
  
  it "is == to a parse failure at the same index expecting the same string" do
    @failure.should == Runtime::TerminalParseFailure.new(@input, 1, "foo")
  end
  
  it "is eql to a parse failure at the same index expecting the same string" do
    @failure.should eql(Runtime::TerminalParseFailure.new(@input, 1, "foo"))
    @failure.hash.should == Runtime::TerminalParseFailure.new(@input, 1, "foo").hash
  end
  
  it "is considered identical to another failure with the same index and expected string in an array" do        
    [Runtime::TerminalParseFailure.new(@input, 1, "foo"), Runtime::TerminalParseFailure.new(@input, 1, "foo")].uniq.size.should == 1
  end
end