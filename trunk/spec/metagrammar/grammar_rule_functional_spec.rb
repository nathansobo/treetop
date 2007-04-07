require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the grammar rule" do
  include MetagrammarSpecContextHelper

  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:grammar)
  end
  
  specify "parses a named empty grammar" do
    result = @parser.parse("grammar Foo end")
    result.value.should be_instance_of(Grammar)
  end

  specify "parses an anonymous empty grammar" do
    result = @parser.parse("grammar end")
    result.value.should be_instance_of(Grammar)
  end

  specify "parses a grammar with one rule" do
    input = 
    %{grammar
        rule foo
          bar
        end
      end}
    result = @parser.parse(input)
    result.should be_success
    grammar = result.value
    grammar.should be_instance_of(Grammar)
    
    grammar.get_parsing_expression(grammar.nonterminal_symbol(:foo)).should be_an_instance_of(NonterminalSymbol)
  end
  
  specify "parses a grammar with two rules" do
    input = 
    %{grammar
        rule foo
          bar
        end
        
        rule baz
          bop
        end
      end}
    result = @parser.parse(input)
    result.should be_success
    
    grammar = result.value
    grammar.should be_instance_of(Grammar)
    
    grammar.get_parsing_expression(grammar.nonterminal_symbol(:foo)).should be_an_instance_of(NonterminalSymbol)
    grammar.get_parsing_expression(grammar.nonterminal_symbol(:baz)).should be_an_instance_of(NonterminalSymbol)
  end
end