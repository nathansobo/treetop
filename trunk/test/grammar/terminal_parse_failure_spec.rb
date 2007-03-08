require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of TerminalParseFailure" do
  setup do
    @expression = mock("failing parsing expression")
    @parse_failure = TerminalParseFailure.new(0, @expression)
  end
  
  specify "has an empty array of nested failures" do
    @parse_failure.nested_failures.should == []
  end
end