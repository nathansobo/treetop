require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

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
  
  specify "on a call to #rule, creates a parsing rule that pairs a nonterminal symbol named after " +
          "the first argument with the parsing expression returned by a call to #build on the builder " +
          "passed as its second argument" do
    
    nonterminal = @grammar.nonterminal_symbol(:foo)

    expression_builder = mock("expression builder")  
    parsing_expression = mock("parsing expression")  
    expression_builder.should_receive(:build).and_return(parsing_expression)
    
    @grammar.should_receive(:add_parsing_rule).with(nonterminal, parsing_expression)
    
    @builder.rule :foo, expression_builder
  end
end