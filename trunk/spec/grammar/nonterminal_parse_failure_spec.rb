require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of NonterminalParseFailure" do
  setup do
    @expression = mock("failing parsing expression")
    @nested_failures = [mock("first nested failure"), mock("second nested failure")]
    @parse_failure = NonterminalParseFailure.new(0, @expression, @nested_failures)
  end
  
  specify "can be initialized with zero or more nested failures" do
    @parse_failure.nested_failures.should == @nested_failures
  end
end