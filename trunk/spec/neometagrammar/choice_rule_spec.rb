dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the choice rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:choice)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a choice between terminals" do
    result = @parser.parse("'a' / 'b' / 'c'")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OrderedChoice)
    value.alternatives[0].prefix.should == 'a'
    value.alternatives[1].prefix.should == 'b'
    value.alternatives[2].prefix.should == 'c'
  end
    
  it "successfully parses and generates Ruby for a choice between nonterminals" do
    result = @parser.parse("a / b / c")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OrderedChoice)
    value.alternatives[0].name.should == :a
    value.alternatives[1].name.should == :b
    value.alternatives[2].name.should == :c
  end
  
  it "successfully parses and generates Ruby for a choice between sequences of terminals" do
    result = @parser.parse("'a' 'b' / 'c' 'd' 'e' / 'f' 'g'")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OrderedChoice)
    value.alternatives[0].should be_an_instance_of(Sequence)
    value.alternatives[1].should be_an_instance_of(Sequence)
    value.alternatives[2].should be_an_instance_of(Sequence)
  end
  
  it "successfully parses a choice between parenthesized ordered choices" do
    result = @parser.parse("('a' / 'b') / ('c' / 'd' / 'e')")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OrderedChoice)
    value.alternatives[0].should be_an_instance_of(OrderedChoice)
    value.alternatives[1].should be_an_instance_of(OrderedChoice)
  end
end