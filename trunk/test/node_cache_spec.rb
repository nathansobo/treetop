require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A new node cache" do
  setup do
    @node_cache = NodeCache.new
  end
  
  specify "is empty" do
    @node_cache.should_be_empty
  end
end

context "A node cache with one node" do
  setup do
    @node_cache = NodeCache.new
    @node = ParseResult.new(mock("Parse value"), 0, 5)
    @node_cache.store_node(:Foo, @node)
  end
  
  specify "is not empty" do
    @node_cache.should_not_be_empty
  end
  
  specify "returns that node when queried with its associated nonterminal symbol and starting index" do
    @node_cache.node_starting_at(:Foo, @node.start_index).should_equal @node
  end
  
  specify "returns nil when queried with the wrong nonterminal" do
    @node_cache.node_starting_at(:Bar, @node.start_index).should_be_nil
  end
  
  specify "returns nil when queried with the wrong starting index" do
    @node_cache.node_starting_at(:Foo, 45).should_be_nil
  end
end


context "A node cache with more than one node" do
  setup do
    @node_cache = NodeCache.new
    @node1 = ParseResult.new(mock("Parse value 1"), 0, 5)
    @node2 = ParseResult.new(mock("Parse value 2"), 1, 3)    
    @node_cache.store_node(:Foo, @node1)
    @node_cache.store_node(:Bar, @node2)
  end
  
  specify "can return either node when queried with its corresponding nonterminal symbol and index" do
    @node_cache.node_starting_at(:Foo, @node1.start_index).should_equal @node1
    @node_cache.node_starting_at(:Bar, @node2.start_index).should_equal @node2
  end
end