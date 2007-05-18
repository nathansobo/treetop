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