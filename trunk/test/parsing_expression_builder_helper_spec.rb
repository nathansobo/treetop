require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

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
end