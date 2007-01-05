require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
  end
  
  specify "is a kind of AtomicParsingExpression" do
    @nonterminal.should_be_a_kind_of AtomicParsingExpression
  end
  
  specify "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should_equal(@grammar)
  end
  
  specify "propagates parse_at to its associated parsing expression" do
    input = mock("input")
    interval = 0...5
    parser = mock("parser")
    parse_result = SyntaxNode.new(input, interval)
    parsing_expression = mock("Associated parsing expression")
    node_cache = NodeCache.new
    
    parser.should_receive(:node_cache).at_least(:twice).and_return(node_cache)
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(parsing_expression)
    parsing_expression.should_receive(:parse_at).with(input, interval.begin, parser).and_return(parse_result)

    @nonterminal.parse_at(input, interval.begin, parser).should_equal parse_result
  end
  
  specify "returns a cached syntax node for repeated calls to parse_at at the same start index" do
    input = mock("input")
    parsing_expression = mock("parsing expression")
    node_cache = NodeCache.new
    parser = mock("parser")
    interval = 0...5
    parse_result = SyntaxNode.new(input, interval)
    
    
    parser.should_receive(:node_cache).at_least(:twice).and_return(node_cache)
    @grammar.should_receive(:get_parsing_expression).once.with(@nonterminal).and_return(parsing_expression)
    parsing_expression.should_receive(:parse_at).with(input, interval.begin, parser).and_return(parse_result)
    
    @nonterminal.parse_at(input, interval.begin, parser).should_equal parse_result
    @nonterminal.parse_at(input, interval.begin, parser).should_equal parse_result
  end
end