require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of ParseFailure" do
  setup do
    @index = 0
    @expression = mock("parsing expression that failed")
    @parse_failure = ParseFailure.new(@index, @expression)
  end
  
  specify "should be failure" do
    @parse_failure.should_be_failure
  end
  
  specify "should not be success" do
    @parse_failure.should_not_be_success
  end 
  
  specify "has a zero length interval at its index" do
    @parse_failure.interval.should_eql @index...@index
  end
  
  specify "can indicate the index where the failure occurred" do
    @parse_failure.index.should == @index
  end
  
  specify "records the parsing expression whose attempted parsing produced it" do
    @parse_failure.parsing_expression.should == @expression
  end

end