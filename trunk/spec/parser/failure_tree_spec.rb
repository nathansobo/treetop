require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A new failure tree whose root is at a given failure index" do
  setup do
    @expression = mock('expression producing the failure tree')
    @index = 68
    @failure_tree = FailureTree.new(@expression, @index, [])
  end
  
  it "holds a reference back to the expression that produced it" do
    @failure_tree.expression.should == @expression
  end
  
  it "has the index with which it was intantiated" do
    @failure_tree.index.should == @index
  end
  
  it "reports its own index as its highest subtree index" do
    @failure_tree.max_subtree_index.should == @index
  end
end

describe "A new failure tree instantiated a single subtree that may have caused the failure leading to the production of this tree or one of its ancestors parent" do
  setup do
    @expression = mock('expression producing the failure tree')
    @index = 68
    
    @subtree = FailureTree.new(mock('subexpression'), 78, [])
    
    @failure_tree = FailureTree.new(@expression, @index, [@subtree])
  end
  
  it "makes it available as one of its subtrees" do
    subtrees = @failure_tree.subtrees
    subtrees.size.should == 1
    subtrees.first.should == @subtree
  end
  
  it "reports the index of its subtree as the highest subtree index" do
    @failure_tree.max_subtree_index.should == @subtree.index
  end
end

describe "A new failure tree instantiated with two subtrees, two with max subtree index index of 8 and one at index 3" do
  setup do
    @expression = mock('expression producing the failure tree')
    @index = 1
    
    @grandchild_1 = FailureTree.new(mock('subexpression'), 8, [])
    @subtree_1 = FailureTree.new(mock('subexpression'), 3, [@grandchild_1])
    
    @grandchild_2 = FailureTree.new(mock('subexpression'), 8, [])
    @subtree_2 = FailureTree.new(mock('subexpression'), 3, [@grandchild_2])
    
    @subtree_3 = FailureTree.new(mock('subexpression'), 3, [])
    
    @failure_tree = FailureTree.new(@expression, @index, [@subtree_1, @subtree_2, @subtree_3])
  end

  it "keeps only the subtrees with the highest subtree indices as its subtrees" do
    subtrees = @failure_tree.subtrees
    subtrees.size.should == 2
    subtrees.should include(@subtree_1)
    subtrees.should include(@subtree_2)
  end
  
  it "reports 8 as its highest subtree index" do
    @failure_tree.max_subtree_index.should == 8
  end
end