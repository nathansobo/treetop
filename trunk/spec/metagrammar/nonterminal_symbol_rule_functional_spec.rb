require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the nonterminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :nonterminal_symbol
  end

  specify "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    with_both_protometagrammar_and_metagrammar do
      syntax_node = @parser.parse('foo')    

      grammar = Grammar.new
      nonterminal = syntax_node.value(grammar)
      nonterminal.should_be_an_instance_of NonterminalSymbol
      nonterminal.name.should_equal :foo
      grammar.nonterminal_symbol(:foo).should_equal(nonterminal)      
    end
  end
  
  specify "parses unquoted strings with underscores successfully" do
    with_both_protometagrammar_and_metagrammar do
      @parser.parse('underscore_rule_name').should be_success
    end
  end

  specify "parses nonterminal names that begin with reserved words successfully" do
    with_both_protometagrammar_and_metagrammar do
      @parser.parse('rule_name').should be_success
      @parser.parse('end_of_the_world').should be_success      
    end
  end
  
  specify "does not parse 'rule' or 'end' as nonterminals" do
    with_both_protometagrammar_and_metagrammar do    
      @parser.parse('rule').should be_a_failure
      @parser.parse('end').should be_a_failure
    end
  end
end