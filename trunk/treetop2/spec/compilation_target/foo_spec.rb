dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

require "#{dir}/foo"

describe "An instance of a hand-built Bar parser" do
  
  setup do
    @parser = Foo.new
  end
  
  it "can parse matching input, associating it with the correct node class" do
    result = @parser.parse('abce')
    result.should be_success
    result.should be_an_instance_of(Foo::Bar)
  end
  
  it "can parse matching input that exercises foo's positive closure" do
    @parser.parse('abcbcbce').should be_success
  end
  
  it "can parse matching input that exercises foo's second alternative" do
    @parser.parse('abde').should be_success
  end
  
  it "fails to parse ae and returns the failure to match 'b' as its sole nested failure" do
    result = @parser.parse('ae')
    result.should be_failure
    
    result.nested_failures.size.should == 1
    nested_failure = result.nested_failures.first
    nested_failure.index.should == 1
    nested_failure.expected_string.should == 'b'    
  end
  
  it "fails to parse abe and returns the failure to match 'c' or 'd' as its nested failures" do
    result = @parser.parse('abe')
    result.should be_failure
    result.nested_failures.size.should == 2
  
    nested_failure = result.nested_failures[0]
    nested_failure.index.should == 2
    nested_failure.expected_string.should == 'c'
    
    nested_failure = result.nested_failures[1]
    nested_failure.index.should == 2
    nested_failure.expected_string.should == 'd'
  end
  
  it "parses the optional expression or epsilon" do
    @parser.root = :optional    
    @parser.parse('foo').should be_success
    @parser.parse('').should be_success
  end
end