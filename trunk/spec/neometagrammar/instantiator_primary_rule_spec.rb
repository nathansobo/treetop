dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the instantiator_primary rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:instantiator_primary)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
      
  it "successfully parses and generates Ruby for zero or more of a nonterminal" do
    result = @parser.parse('foo*')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(ZeroOrMore)
    value.repeated_expression.name.should == :foo
  end
  
  it "successfully parses and generates Ruby for one or more of a nonterminal" do
    result = @parser.parse('foo+')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OneOrMore)
    value.repeated_expression.name.should == :foo
  end

  it "successfully parses and generates Ruby for zero or more of a terminal" do
    result = @parser.parse('"foo"*')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(ZeroOrMore)
    value.repeated_expression.prefix.should == 'foo'
  end
    
  it "successfully parses and generates Ruby for one or more of a terminal" do
    result = @parser.parse('"foo"+')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OneOrMore)
    value.repeated_expression.prefix.should == 'foo'
  end
  
  it "successfully parses and generates Ruby for zero or more of a sequence" do
    result = @parser.parse('(a b c)*')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(ZeroOrMore)
    value.repeated_expression.should be_an_instance_of(Sequence)
  end
  
  it "successfully parses and generates Ruby for one or more of a choice" do
    result = @parser.parse('(a / b / c)+')
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OneOrMore)
    value.repeated_expression.should be_an_instance_of(OrderedChoice)
  end
end