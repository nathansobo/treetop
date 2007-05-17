require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A Grammar builder" do
  setup do
    @grammar = Grammar.new
    @builder = GrammarBuilder.new(@grammar)
  end
  
  specify "instance evaluates blocks passed to #build" do
    @builder.should_receive(:foo)
    @builder.build do
      foo
    end
  end
  
  specify "sets the grammar root to a nonterminal with the name passed to #root" do
    nonterminal = @grammar.nonterminal_symbol(:foo)
    
    @grammar.should_receive(:root=).with(nonterminal)

    @builder.build do
      root :foo
    end
  end
  
  specify "on a call to #rule, creates a parsing rule with the second argument as its expression" +
          "if it is already a parsing expression" do
    nonterminal = @grammar.nonterminal_symbol(:foo)
    parsing_expression = ParsingExpression.new
    @grammar.should_receive(:add_parsing_rule).with(nonterminal, parsing_expression)
    @builder.rule :foo, parsing_expression
  end
  
  specify "on a call to #rule, creates a parsing rule with the results of calling #build second argument " +
          "if it is builder, after setting its grammar" do
    
    nonterminal = @grammar.nonterminal_symbol(:foo)

    expression_builder = ParsingExpressionBuilder.new
    parsing_expression = mock("parsing expression")
    expression_builder.should_receive(:grammar=).with(@grammar)
    expression_builder.should_receive(:build).and_return(parsing_expression)
    
    @grammar.should_receive(:add_parsing_rule).with(nonterminal, parsing_expression)
    
    @builder.rule :foo, expression_builder
  end
end