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

context "A NonterminalParseFailure with multiple layers of nested failures" do
  setup do
    @terminal_failure_1 = TerminalParseFailure.new(0, mock('terminal expression 1'))
    @terminal_failure_2 = TerminalParseFailure.new(5, mock('terminal expression 2'))
    @terminal_failure_3 = TerminalParseFailure.new(3, mock('terminal expression 3'))

    nested_terminal_failures = [@terminal_failure_1, @terminal_failure_2, @terminal_failure_3]
    nested_failures = [NonterminalParseFailure.new(0, @expression, nested_terminal_failures)]
    @failure = NonterminalParseFailure.new(0, @expression, nested_failures)
  end
  
  specify "can return all nested nonterminal failures, sorted with highest index first" do
    @failure.nested_terminal_failures.should == [@terminal_failure_2, @terminal_failure_3, @terminal_failure_1]
  end
  
  specify "has three nested failure chains, sorted backward by their terminal indices" do    
    failure_chains = @failure.nested_failure_chains
    failure_chains.size.should == 3
    
    indices = failure_chains.collect(&:terminal_index)
    sorted_indices = indices.sort.reverse
    
    indices.should == sorted_indices
    
  end
  
  specify "has three failure chains, each three failures in length" do
    failure_chains = @failure.failure_chains

    failure_chains.size.should == 3
    failure_chains.each do |failure_chain|
      failure_chain.failures.size.should == 3
    end
  end
end

