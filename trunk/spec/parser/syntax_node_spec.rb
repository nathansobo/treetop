require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of SyntaxNode" do
  setup do
    @nested_failures = [mock("nested failure")]
    @node = SyntaxNode.new(mock("input"), mock("interval"), @nested_failures)
  end
  
  specify "should be success" do
    @node.should_be_success
  end
  
  specify "should not be failure" do
    @node.should_not_be_failure
  end
  
  specify "can propagate a nested parse failures" do
    @node.nested_failures.should == @nested_failures
  end

end