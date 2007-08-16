dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A terminal parse failure" do

  
  setup do
    @failure = Parser::TerminalParseFailure.new(1, "foo")
  end
  
  it "is == to a parse failure at the same index expecting the same string" do
    @failure.should == Parser::TerminalParseFailure.new(1, "foo")
  end
  
  it "is eql to a parse failure at the same index expecting the same string" do
    @failure.should eql(Parser::TerminalParseFailure.new(1, "foo"))
    @failure.hash.should == Parser::TerminalParseFailure.new(1, "foo").hash
  end
  
  it "is considered identical to another failure with the same index and expected string in an array" do        
    [Parser::TerminalParseFailure.new(1, "foo"), Parser::TerminalParseFailure.new(1, "foo")].uniq.size.should == 1
  end
end