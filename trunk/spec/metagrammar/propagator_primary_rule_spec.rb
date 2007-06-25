dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the propagator_primary rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:propagator_primary)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for & preceding a terminal" do
    result = @parser.parse('&"foo"')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(AndPredicate)
    value.expression.prefix.should == 'foo'
  end
  
  it "successfully parses and generates Ruby for ! preceding a nonterminal" do
    result = @parser.parse('!foo')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(NotPredicate)
    value.expression.name.should == :foo
  end
  
  it "successsfully parses and generates Ruby for & preceding one or more of a nonterminal, which is wasteful but valid" do
    result = @parser.parse('&foo+')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(AndPredicate)
    value.expression.should be_an_instance_of(OneOrMore)
  end
  
  it "successsfully parses ! preceding zero or more of a parenthesized choice" do
    result = @parser.parse('!(a / b / c)')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(NotPredicate)
    value.expression.should be_an_instance_of(OrderedChoice)
  end
  
  it "successsfully parses and generates Ruby for an optional nonterminal" do
    result = @parser.parse('a?')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Optional)
    value.expression.name.should == :a
  end
  
  it "successsfully parses an optional terminal" do
    result = @parser.parse('"a"?')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Optional)
    value.expression.prefix.should == 'a'
  end
    
  it "fails to parse ! or & preceding an optional terminal or nonterminal, because predicating over an optional expression is nonsensical" do
    @parser.parse('!foo?').should be_failure
    @parser.parse('&foo?').should be_failure
    @parser.parse('!"foo"?').should be_failure
    @parser.parse('&"foo"?').should be_failure
  end
end