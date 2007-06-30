dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the primary rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:primary)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
    
    Object.class_eval do
      class TestTerminalNodeClass < TerminalSyntaxNode
      end
      
      class TestSequenceNodeClass < SequenceSyntaxNode
      end
    end
  end
  
  after do
    reset_metagrammar_root
    teardown_global_constant(:Bar)
    teardown_global_constant(:TestTerminalNodeClass)
    teardown_global_constant(:TestSequenceNodeClass)
  end
  
  it "successfully parses and generates Ruby for a terminal followed by a node class expression and a block" do
    
    result = @parser.parse("label:'foo' <TestTerminalNodeClass> { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(TerminalSymbol)
    value.label.should == :label
    value.node_class.should == TestTerminalNodeClass
    value.node_class.instance_methods.should include('a_method')
    
  end
  
  it "successfully parses and generates Ruby for a labeled one or more of a nonterminal followed by a node class expression and a block" do
    result = @parser.parse("label:foo+ <TestSequenceNodeClass> { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OneOrMore)
    value.label.should == :label
    value.node_class.should == TestSequenceNodeClass
    value.node_class.instance_methods.should include('a_method')
  end
  
  it "successfully parses and generates Ruby for a labeled parenthesized sequence of terminals followed by a node class expression and a block" do
    result = @parser.parse("label:('a' 'b' 'c') <TestSequenceNodeClass> { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.label.should == :label
    value.node_class.should == TestSequenceNodeClass
    value.node_class.instance_methods.should include('a_method')
  end
end