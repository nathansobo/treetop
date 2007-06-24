dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the sequence rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:sequence)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a sequence of terminals" do
    result = @parser.parse("'a' 'b' 'c'")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].prefix.should == 'a'
    value.elements[1].prefix.should == 'b'
    value.elements[2].prefix.should == 'c'
  end
  
  it "successfully parses and generates Ruby for a sequence of nonterminals" do
    result = @parser.parse("a b c")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].name.should == :a
    value.elements[1].name.should == :b
    value.elements[2].name.should == :c
  end
  
  it "successfully parses and generates Ruby for a sequence of terminals, each followed by blocks" do
    result = @parser.parse("'a' { def a_method; end } 'b' { def b_method; end } 'c' { def c_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].node_class.instance_methods.should include('a_method')
    value.elements[1].node_class.instance_methods.should include('b_method')
    value.elements[2].node_class.instance_methods.should include('c_method')
  end
  
  it "successfully parses and generates Ruby for a sequence of parenthesized choices" do
    result = @parser.parse("(a / b) (c / d) (e / f)")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].should be_an_instance_of(OrderedChoice)
  end
  
  it "successfully parses and generates Ruby for a sequence repeated nonterminals, each followed by blocks" do
    result = @parser.parse("a+ { def a_method; end } b* { def b_method; end } c+ { def c_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.elements[0].node_class.instance_methods.should include('a_method')
    value.elements[1].node_class.instance_methods.should include('b_method')
    value.elements[2].node_class.instance_methods.should include('c_method')
  end
  
  it "successfully parses a sequence of nonterminals followed by a block" do
    @parser.parse("a b c { def a_method; end }")
  end
end