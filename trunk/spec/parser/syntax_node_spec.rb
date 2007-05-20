require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SyntaxNode, " instantiated without nested failures" do
  before do
    @node = SyntaxNode.new(mock("input"), mock("interval"))
  end
  
  it "should be success" do
    @node.should be_success
  end
  
  it "should not be failure" do
    @node.should_not be_failure
  end
  
  it "should not be epsilon" do
    @node.should_not be_epsilon
  end
  
  it "has no nested failures" do
    @node.nested_failures.should == []
  end
end

describe SyntaxNode, " instantiated with multiple nested failures" do
  before(:each) do
    @index = 0
    @nested_failures = [5, 5, 3, 0].collect {|index| terminal_parse_failure_at(index)}
    @node = SyntaxNode.new(mock('input'), mock('interval'), @nested_failures)
  end
  
  it "retains those nested failures with the highest index" do
    nested_failures = @node.nested_failures
    nested_failures.size.should == 2
    nested_failures[0].index.should == 5
    nested_failures[1].index.should == 5
  end
  
  it "retains its existing nested failures when updated with a set of new failures whose indices are less than the index of its existing nested failures" do
    new_nested_failures = [1, 2, 3].collect {|index| terminal_parse_failure_at(index)}
    
    nested_failures_before_update = @node.nested_failures.clone
    @node.update_nested_failures(new_nested_failures)
    @node.nested_failures.should == nested_failures_before_update
  end
  
  it "adds to existing nested failures if updated with a set of existing failures with a maximum index equal to the existing maximum index" do
    new_nested_failure = terminal_parse_failure_at(5)
    
    pre_update_nested_failure_count = @node.nested_failures.size
    @node.update_nested_failures([new_nested_failure])
    @node.nested_failures.size.should == pre_update_nested_failure_count + 1
    @node.nested_failures.should include(new_nested_failure)
  end
end