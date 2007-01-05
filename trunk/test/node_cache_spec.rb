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

context "A node cache with one node stored in it" do
  setup do
    @node_cache = NodeCache.new
    @interval = 4...7
    @node = SyntaxNode.new(mock("input"), @interval)
    @nonterminal = NonterminalSymbol.new(:foo, mock("parser"))
    @node_cache.store_node(@nonterminal, @node)
  end
  
  specify "is not empty" do
    @node_cache.should_not_be_empty
  end
  
  specify "returns that node when queried with its associated nonterminal symbol and starting index" do
    @node_cache.node_starting_at(@nonterminal, @interval.begin).should_equal @node
  end
  
  specify "returns nil when queried with the wrong nonterminal" do
    other_nonterminal = NonterminalSymbol.new(:bar, mock("parser"))
    @node_cache.node_starting_at(other_nonterminal, @interval.begin).should_be_nil
  end
  
  specify "returns nil when queried with the wrong starting index" do
    wrong_index = 2
    wrong_index.should_not_equal @interval.begin
    @node_cache.node_starting_at(@nonterminal, wrong_index).should_be_nil
  end
end


context "A node cache with more than one node cached for the same nonterminal" do
  setup do
    @node_cache = NodeCache.new
    
    @nonterminal = NonterminalSymbol.new(:foo, mock("parser"))
    @node1 = SyntaxNode.new(mock("input"), 0...5)
    @node2 = SyntaxNode.new(mock("input"), 1...3)
    @node_cache.store_node(@nonterminal, @node1)
    @node_cache.store_node(@nonterminal, @node2)
  end
  
  specify "can return either node when queried with its corresponding nonterminal symbol and index" do
    @node_cache.node_starting_at(@nonterminal, @node1.interval.begin).should_equal @node1
    @node_cache.node_starting_at(@nonterminal, @node2.interval.begin).should_equal @node2
  end
end

context "A node cache with more than one node cached for different nonterminals on the same interval" do
  setup do
    @node_cache = NodeCache.new
    
    @nonterminal1 = NonterminalSymbol.new(:foo, mock("parser"))
    @nonterminal2 = NonterminalSymbol.new(:bar, mock("parser"))
    @interval = 0...5
    @node1 = SyntaxNode.new(mock("input"), @interval)
    @node2 = SyntaxNode.new(mock("input"), @interval)
    @node_cache.store_node(@nonterminal1, @node1)
    @node_cache.store_node(@nonterminal2, @node2)
  end
  
  specify "can return either node when queried with its corresponding nonterminal symbol and index" do
    @node_cache.node_starting_at(@nonterminal1, @interval.begin).should_equal @node1
    @node_cache.node_starting_at(@nonterminal2, @interval.begin).should_equal @node2
  end
end