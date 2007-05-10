require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new failed parse result, instantiated without any failure subtrees that may have caused the failure" do
  setup do
    @expression = mock('expression that failed to parse')
    @failure_index = 3
    @result = FailedParseResult.new(@expression, @failure_index, [])
  end
  
  specify "is a failure" do
    @result.should be_a_failure
    @result.should_not be_a_success
  end
  
  specify "has a zero length consumed interval starting at the index at which the failure occurred" do
    @result.consumed_interval.should == (@failure_index...@failure_index)
  end
  
  specify "has one failure leaf rooted at its the index of the failure with a reference back to the failing expression" do
    failure_leaf = @result.failure_tree
    failure_leaf.should be_an_instance_of(FailureLeaf)
    failure_leaf.expression.should == @expression
  end
end

context "A new failed parse result, instantiated with one failure subtree that caused the failure" do
  setup do
    @expression = mock('expression that failed to parse')
    @failure_index = 3
    @failure_subtrees = [FailureTree.new(mock('expression'), 7, [])]
    @result = FailedParseResult.new(@expression, @failure_index, @failure_subtrees)
  end
  
  specify "propagates the failure subtree as a subtree of its failure tree" do
    @result.failure_tree.subtrees.should == @failure_subtrees
  end
end