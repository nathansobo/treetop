require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A new grammar" do
  setup do
    @grammar = Grammar.new
  end

  specify "returns an instance of Parser in response to new_parser" do
    @grammar.new_parser.should_be_an_instance_of(Parser)
  end
  
  specify "returns unique parsers in response to repeated calls to new_parser" do
    @grammar.new_parser.should_be_an_instance_of(Parser)
  end
  
  specify "returns parsers that retain a reference to that grammar" do
    @grammar.new_parser.grammar.should_equal @grammar
  end
end

context "A grammar with a parsing rule" do
  setup do
    @grammar = Grammar.new
    nonterminal = NonterminalSymbol.new(:Foo, @grammar)
    @rule = ParsingRule.new(nonterminal, mock("Parsing expression"))
    @grammar.add_parsing_rule(@rule)
  end
  
  specify "can retrive the parsing expression associated with that rule based on its nonterminal symbol" do
    @grammar.get_parsing_expression(@rule.nonterminal_symbol).should_equal @rule.parsing_expression
  end
end