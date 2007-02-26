require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of ParseFailure with a single expectation descriptor" do
  setup do
    @index = 0
    @expectation = mock('expectation')
    @parse_failure = ParseFailure.new(@index, @expectation)
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
  
  specify "has an array of descriptors for what may have caused the failure at its index" do
    @parse_failure.descriptors[0].should == @expectation
  end
  
  specify "has a string representation describing what was expected at its index" do
    expression = mock('expected expression')
    @expectation.stub!(:expression).and_return(expression)
    expression.stub!(:to_s).and_return('foo')

    @parse_failure.to_s.should == "Expected a prefix matching foo at index #{@index}."
  end
end

context "An instance of parse failure with two descriptors" do
  setup do
    @index = 0
    @expectation1 = mock('first expectation')
    @expectation2 = mock('alternative expectation')
    @parse_failure = ParseFailure.new(@index, @expectation1, @expectation2)
  end
  
  specify "has a string representation describing both possible expectations" do
    expression1 = mock('first expected expression')
    @expectation1.stub!(:expression).and_return(expression1)
    expression1.stub!(:to_s).and_return('foo')

    expression2 = mock('second expected expression')
    @expectation2.stub!(:expression).and_return(expression2)
    expression2.stub!(:to_s).and_return('bar')
    
    @parse_failure.to_s.should == "Expected a prefix matching foo or bar at index #{@index}."
  end
end
  
