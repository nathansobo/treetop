dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

require "#{dir}/arithmetic"

describe "An instance of a hand-built Arithmetic parser" do
  
  setup do
    @parser = Arithmetic.new
  end

  it "successfully parses a number" do
    result = @parser.parse('1')
    result.should be_success
    result.value.should == 1
  end
  
  it "successfully parses a multi-digit number" do
    result = @parser.parse('123')
    result.should be_success
    result.value.should == 123
  end
  
  it "successfully parses an addition" do
    result = @parser.parse('3+4')
    result.should be_success
    result.value.should == 7
  end
  
  it "successfully parses a ridiculous addition" do
    result = @parser.parse('4+30+200+1000')
    result.should be_success
    result.value.should == 1234
  end
end