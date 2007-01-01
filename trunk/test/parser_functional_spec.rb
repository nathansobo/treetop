require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A parser for a grammar that contains only atomic symbols" do
  setup do
    @grammar = Grammar.new
    
    terminal = TerminalSymbol.new("bar")
    nonterminal = NonterminalSymbol.new(:Foo, @grammar)
    parse_rule = ParsingRule.new(nonterminal, terminal)
    
    @grammar.add_parsing_rule(parse_rule)
    @parser = @grammar.new_parser
  end
  
  specify "returns a kind of SyntaxNode upon a successful parse" do
    input = "bar"
    @parser.parse(input).should_be_a_kind_of(SyntaxNode)
  end
  
  specify "returns a SyntaxNode with a text value equal to the input upon a successful parse" do
    input = "bar"
    @parser.parse(input).text_value.should_eql input
  end
  
end