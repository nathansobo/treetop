require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of ParseFailure" do
  setup do
    @index = 0
    @expression = mock("expression")
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
  
  specify "returns the expression that failed if it was supplied as the " +
          "second argument to initialize" do
    @parse_failure.expression.should == @expression
  end
end