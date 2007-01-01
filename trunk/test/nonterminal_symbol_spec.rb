require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:Foo, @grammar)
  end
  
  specify "is a kind of AtomicParsingExpression" do
    @nonterminal.should_be_a_kind_of AtomicParsingExpression
  end
  
  specify "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should_equal(@grammar)
  end
  
  specify "propagates parse_at to its associated parsing expression" do
    input = "foobar"
    index = 0
    parser = mock("Parser")
    parse_result = mock("Parse result")
    parsing_expression = mock("Associated parsing expression")
    
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(parsing_expression)
    parsing_expression.should_receive(:parse_at).with(input, index, parser).and_return(parse_result)

    @nonterminal.parse_at(input, index, parser).should_equal parse_result
  end
end