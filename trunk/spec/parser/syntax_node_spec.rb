require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe SyntaxNode, " instantiated without nested failures" do
  setup do
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
  
end