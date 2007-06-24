dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the parsing_rule rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:parsing_rule)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a parsing rule" do
    result = @parser.parse("rule foo 'bar' end")
    result.should be_success

    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(ParsingRule)
    value.nonterminal_symbol.name.should == :foo
    value.parsing_expression.prefix.should == 'bar'
    
    eval(result.add_rule_ruby(@grammar_node_mock))
    Bar.get_parsing_expression(Bar.nonterminal_symbol(:foo)).prefix.should == 'bar'
  end
end