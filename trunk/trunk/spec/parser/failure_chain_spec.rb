require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A failure chain" do
  setup do
    @terminal_failure = TerminalParseFailure.new(0, mock('expression'))
    @failure_chain = FailureChain.new(@terminal_failure)
  end
  
  specify "has a terminal index equal to that of its terminal element" do
    @failure_chain.terminal_index.should == @terminal_failure.index
  end
  
  specify "allows failures to be added to it, returning itself" do
    another_failure = mock('failure')
    @failure_chain.add(another_failure).should == @failure_chain
    @failure_chain.failures[0].should == another_failure
  end
end