require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
  end
  
  specify "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should_equal(@grammar)
  end
  
  specify "propagates parse_at to its associated parsing expression" do
    input = mock("input")
    start_index = 0
    parser = parser_with_empty_cache_mock

    parse_result = SyntaxNode.new(input, start_index...5)
    parsing_expression = mock("Associated parsing expression")
    
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(parsing_expression)
    parsing_expression.should_receive(:parse_at).with(input, start_index, parser).and_return(parse_result)

    @nonterminal.parse_at(input, start_index, parser).should_equal parse_result
  end
  
  specify "checks its node cache for a stored node at a given start index" do    
    start_index = 0
    stored_node = mock('stored node')
    node_cache = mock("node cache")
    
    @nonterminal.stub!(:node_cache).and_return(node_cache)
    node_cache.should_receive(:[]).with(start_index).and_return(stored_node)
    
    @nonterminal.parse_at(mock("input"), start_index, mock('parser')).should_equal stored_node
  end
  
  specify "stores its parse result in the node cache before returning it" do    
    input = mock('input')
    start_index = 0
    parser = mock('parser')
    node_cache = mock("node cache")
    
    @nonterminal.stub!(:node_cache).and_return(node_cache)
    node_cache.should_receive(:[]).with(start_index).and_return(nil)
    
    parse_result = mock('parse result')
    @nonterminal.should_receive(:parse_at_without_caching).with(input, start_index, parser).and_return(parse_result)
    
    node_cache.should_receive(:store).with(parse_result).and_return(parse_result)
    @nonterminal.parse_at(input, start_index, parser).should_equal parse_result
  end
  
  specify "has a node cache stored in the parser" do
    node_cache = mock('stored_node')
    @parser.should_receive(:node_cache_for).with(@nonterminal).and_return(node_cache)
    @nonterminal.node_cache(@parser).should == node_cache
  end
  
  specify "has a string representation" do
    @nonterminal.to_s.should == 'foo'
  end
end