require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new successful parse result, instantiated without any failure subtrees" do
  setup do
    @expression = mock('expression yielding the parse')    
    @syntax_node = mock('syntax node yielded by the parse')
    @result = SuccessfulParseResult.new(@expression, @syntax_node, [])
  end
  
  specify "is a success" do
    @result.should be_a_success
    @result.should_not be_a_failure
  end
  
  specify "propagates the value yielded by the parse" do
    @result.value.should == @syntax_node
  end
  
  specify "represents the interval covered by the successful result as its consumed interval" do
    interval = mock('interval')
    @syntax_node.should_receive(:interval).and_return(interval)
    @result.consumed_interval.should == interval
  end
  
  specify "has a nil failure_tree" do
    @result.failure_tree.should be_nil
  end
end

context "A new successful parse result, instantiated a with failure subtree" do
  setup do
    @expression = mock('expression yielding the parse')
    @syntax_node = mock('syntax node yielded by the parse')
    @interval = 3...4
    @syntax_node.stub!(:interval).and_return(@interval)
    @failure_subtrees = [mock('failure subtree')]
    @result = SuccessfulParseResult.new(@expression, @syntax_node, @failure_subtrees)
  end
  
  specify "has a failure tree with the subtrees provided during instantiation with an index matching the beginning of the value's interval" do
    failure_tree = @result.failure_tree
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.subtrees.should == @failure_subtrees
    failure_tree.index.should == @interval.begin
  end
end