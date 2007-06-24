dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the primary rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:primary)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for a terminal followed by a block" do
    result = @parser.parse("'foo' { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(TerminalSymbol)
    value.node_class.instance_methods.should include('a_method')
  end
  
  it "successfully parses and generates Ruby for one or more of a nonterminal followed by a block" do
    result = @parser.parse("foo+ { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(OneOrMore)
    value.node_class.instance_methods.should include('a_method')
  end
  
  it "successfully parses and generates Ruby for a parenthesized sequence of terminals followed by a block" do
    result = @parser.parse("('a' 'b' 'c') { def a_method; end }")
    result.should be_success
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(Sequence)
    value.node_class.instance_methods.should include('a_method')
  end
end