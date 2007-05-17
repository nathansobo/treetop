require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of ParseFailure instantiated with no failure paths" do
  setup do
    @matched_interval_begin = 0
    @expression = mock("parsing expression that failed")    
    @parse_failure = ParseFailure.new(@matched_interval_begin, @expression, [])
  end
  
  specify "should be failure" do
    @parse_failure.should be_failure
  end
  
  specify "should not be success" do
    @parse_failure.should_not_be_success
  end 
  
  specify "has a zero length interval at the beginning of its match interval" do
    @parse_failure.interval.should == (@matched_interval_begin...@matched_interval_begin)
  end
      
  specify "records the parsing expression whose attempted parsing produced it" do
    @parse_failure.parsing_expression.should == @expression
  end
end