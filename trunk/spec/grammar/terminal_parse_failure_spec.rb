require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of TerminalParseFailure" do
  setup do
    @expression = mock("failing parsing expression")
    @parse_failure = TerminalParseFailure.new(0, @expression)
  end
  
  specify "has an initially empty array of nested failures" do
    @parse_failure.nested_failures.should == []
  end
  
  specify "includes itself in nested terminal failures" do
    @parse_failure.nested_terminal_failures.should_include @parse_failure
  end
  
  specify "returns one failure chain ending in itself" do
    failure_chains = @parse_failure.failure_chains
    failure_chains.size.should == 1
    failure_chains[0].terminal_failure.should == @parse_failure
  end
end