require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An instance of ParseFailure instantiated with no failure paths" do
  setup do
    @matched_interval_begin = 0
    @expression = mock("parsing expression that failed")    
    @parse_failure = ParseFailure.new(@expression, @matched_interval_begin)
  end
  
  it "should be failure" do
    @parse_failure.should be_failure
  end
  
  it "should not be success" do
    @parse_failure.should_not be_success
  end 
  
  it "has a zero length interval at the beginning of its match interval" do
    @parse_failure.interval.should == (@matched_interval_begin...@matched_interval_begin)
  end
      
  it "records the parsing expression whose attempted parsing produced it" do
    @parse_failure.expression.should == @expression
  end
end