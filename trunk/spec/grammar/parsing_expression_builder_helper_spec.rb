require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A builder object extended with the ParsingExpressionBuilderHelper module and an assigned grammar" do
  setup do
    @builder = Object.new
    @builder.extend ParsingExpressionBuilderHelper
    @grammar = Grammar.new
    @builder.grammar = @grammar
  end
  
  specify "implements a #nonterm method that converts Ruby symbols to nonterminal symbols from the grammar" do
    @grammar.should_receive(:nonterminal_symbol).with(:foo)
    @builder.nonterm(:foo)
  end
  
  specify "implements a #term method that converts Ruby strings into terminal symbols" do
    prefix = "foo"
    terminal = @builder.term(prefix)
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql prefix
  end
  
  specify "implements an #exp method that converts Ruby strings or symbols into terminal and nonterminal " +
          "symbols respectively and returns arguments that are already parsing expressions unchanged" do
    string = "foo"
    terminal = @builder.exp(string)
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql string
    
    symbol = :foo
    nonterminal = @builder.exp(symbol)
    nonterminal.should_be_an_instance_of NonterminalSymbol
    nonterminal.name.should_equal symbol
    
    expression = ParsingExpression.new
    @builder.exp(expression).should_equal expression
  end
  
  specify "implements an #exp method that converts an array into an arrays of exp called on the original " +
          "array's elements" do
    @builder.exp([:foo]).should_eql([@builder.exp(:foo)])
  end

  specify "implements an #any method that returns an instance of AnythingSymbol" do
    @builder.any.should_be_an_instance_of AnythingSymbol
  end
  
  specify "implements a #char_class method that returns a CharacterClass based on its argument" do
    char_class = @builder.char_class('A-Z')
    char_class.should_be_an_instance_of CharacterClass
    char_class.prefix_regex.should_eql(/^[A-Z]/)
  end
  
  specify "implements a #notp method that creates a NotPredicate with the value of #exp for its argument" do
    expression = mock("parsing expression")
    not_predicate = mock("not predicate")
    @builder.should_receive(:exp).with(expression).and_return(expression)
    expression.should_receive(:not_predicate).and_return(not_predicate)
    @builder.notp(expression).should_equal not_predicate
  end

  specify "implements an #andp method that creates an AndPredicate with the value of #exp for its argument" do
    expression = mock("parsing expression")
    and_predicate = mock("and predicate")
    @builder.should_receive(:exp).with(expression).and_return(expression)
    expression.should_receive(:and_predicate).and_return(and_predicate)
    @builder.andp(expression).should_equal and_predicate
  end

  specify "implements an #optional method that creates an Optional expression out of its argument" do
    result = @builder.optional("foo")
    result.should be_an_instance_of(Optional)
    result.expression.should be_an_instance_of(TerminalSymbol)
  end
  
  specify "implements a #seq method that creates a Sequence from the value of #exp for its arguments" do
    expressions = [:foo, :bar, :baz]
    sequence = @builder.seq(*expressions)
    sequence.should_be_an_instance_of Sequence
    sequence.elements.should_eql @builder.exp(expressions)
  end
  
  specify "implements a #seq method that calls node_class_eval on the generated Sequence if a block is provided" do
    sequence = @builder.seq(:foo) do
      def foo
      end
    end
    sequence.node_class.instance_methods.should_include("foo")
  end
  
  specify "implements a #choice method that creates an OrderedChoice from the value of #exp for each of its arguments" do
    expressions = [:foo, :bar, :baz]
    choice = @builder.choice(*expressions)
    choice.should_be_an_instance_of OrderedChoice
    choice.alternatives.should_eql @builder.exp(expressions)
  end
  
  specify "implements a #zero_or_more method that returns zero_or_more of exp(argument)" do
    zero_or_more = @builder.zero_or_more(:foo)
    zero_or_more.should_be_an_instance_of ZeroOrMore
    zero_or_more.repeated_expression.should_eql(@builder.exp(:foo))
  end
  
  specify "implements a #one_or_more method that returns one_or_more of exp(argument)" do
    one_or_more = @builder.one_or_more(:foo)
    one_or_more.should_be_an_instance_of OneOrMore
    one_or_more.repeated_expression.should_eql(@builder.exp(:foo))
  end
end