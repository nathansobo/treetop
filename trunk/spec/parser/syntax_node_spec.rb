require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An instance of SyntaxNode" do
  setup do
    @node = SyntaxNode.new(mock("input"), mock("interval"))
  end
  
  specify "should be success" do
    @node.should_be_success
  end
  
  specify "should not be failure" do
    @node.should_not_be_failure
  end
  
  specify "should not be epsilon" do
    @node.should_not be_epsilon
  end
end