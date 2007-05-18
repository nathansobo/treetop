require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A new failed parse result" do
  setup do
    @expression = mock('expression that failed to parse')
    @failure_index = 3
    @result = ParseFailure.new(@expression, @failure_index)
  end
  
  it "is a failure" do
    @result.should be_a_failure
    @result.should_not be_a_success
  end
  
  it "has a zero length consumed interval starting at the index at which the failure occurred" do
    @result.interval.should == (@failure_index...@failure_index)
  end
end