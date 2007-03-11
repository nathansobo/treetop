require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A SequenceSyntaxNode" do
  setup do
    @nested_failures = [mock('first nested failure'), mock('second nested failure')]
    @syntax_node = SequenceSyntaxNode.new(mock('input'), mock('interval'), mock('elements'), @nested_failures)
  end
  
  specify "propagates nested failures" do
    @syntax_node.nested_failures.should == @nested_failures
  end
end