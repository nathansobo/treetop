require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the sequence rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :sequence
  end

  specify "parses a series of space-separated terminals and nonterminals as a sequence" do
    with_both_protometagrammar_and_metagrammar do
      syntax_node = @parser.parse('"terminal" nonterminal1 nonterminal2')
      syntax_node.should be_success  

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should_be_an_instance_of Sequence
      sequence.elements[0].should_be_an_instance_of TerminalSymbol
      sequence.elements[0].prefix.should_eql "terminal"
      sequence.elements[1].should_be_an_instance_of NonterminalSymbol
      sequence.elements[1].name.should_equal :nonterminal1
      sequence.elements[2].should_be_an_instance_of NonterminalSymbol
      sequence.elements[2].name.should_equal :nonterminal2
    end
  end
  
  specify "parses a series of space-separated non-terminals as a sequence" do
    with_both_protometagrammar_and_metagrammar do
      syntax_node = @parser.parse('a b c')

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should_be_an_instance_of Sequence      
    end
  end
  
  specify "node class evaluates a block following a sequence in the parsing expression for that sequence" do
    with_both_protometagrammar_and_metagrammar do
      result = @parser.parse("a b c {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should_be_an_instance_of Sequence
      sequence.node_class.instance_methods.should include('a_method')      
    end
  end
  
  specify "binds trailing blocks more tightly to terminal symbols than sequences" do
    with_both_protometagrammar_and_metagrammar do
      result = @parser.parse("a b 'c' {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should_be_an_instance_of Sequence
      sequence.node_class.instance_methods.should_not include('a_method')
      sequence.elements[2].node_class.instance_methods.should include('a_method')      
    end
  end
end