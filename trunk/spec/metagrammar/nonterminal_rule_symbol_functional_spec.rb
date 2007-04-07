require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the nonterminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:nonterminal_symbol)
  end

  specify "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    syntax_node = @parser.parse('foo')    

    grammar = Grammar.new
    nonterminal = syntax_node.value(grammar)
    nonterminal.should_be_an_instance_of NonterminalSymbol
    nonterminal.name.should_equal :foo
    grammar.nonterminal_symbol(:foo).should_equal(nonterminal)
  end
  
  specify "does not parse 'rule' or 'end' as nonterminals" do
    @parser.parse('rule').should be_a_failure
    @parser.parse('end').should be_a_failure
  end
end