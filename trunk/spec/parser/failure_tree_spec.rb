require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new failure tree whose root is at a given failure index" do
  setup do
    @expression = mock('expression producing the failure tree')
    @index = 68
    @failure_tree = FailureTree.new(@expression, @index, [])
  end
  
  specify "holds a reference back to the expression that produced it" do
    @failure_tree.expression.should == @expression
  end
  
  specify "has the index with which it was intantiated" do
    @failure_tree.index.should == @index
  end
end

context "A new failure tree instantiated with subtrees" do
  setup do
    @expression = mock('expression producing the failure tree')
    @index = 68
    @subtrees = mock('array of subtrees')
    @failure_tree = FailureTree.new(@expression, @index, @subtrees)
  end
  
  specify "makes them available as its subtrees" do
    @failure_tree.subtrees.should == @subtrees
  end
end