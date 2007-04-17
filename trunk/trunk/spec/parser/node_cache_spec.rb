require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new node cache" do
  setup do
    @node_cache = NodeCache.new
  end
  
  specify "is empty" do
    @node_cache.should_be_empty
  end
end

context "A node cache with one stored syntax node" do
  setup do
    @node_cache = NodeCache.new
    @interval = 7...29
    @syntax_node = SyntaxNode.new(mock('input'), @interval, [])
    @node_cache.store(@syntax_node)
  end
  
  specify "returns that syntax node when queried at the start of its interval" do
    @node_cache[@interval.begin].should == @syntax_node
  end
end