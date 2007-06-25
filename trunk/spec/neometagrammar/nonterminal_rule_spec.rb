dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the nonterminal rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:nonterminal)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end
  
  it "successfully parses and generates Ruby for 'foo'" do
    result = @parser.parse('foo')
    result.should be_success
    
    value = eval(result.to_ruby(@grammar_node_mock))
    value.should be_an_instance_of(NonterminalSymbol)
    value.should == Bar.nonterminal_symbol(:foo)
  end
  
  
  it "successfully parses unquoted strings with underscores" do
    @parser.parse('underscore_rule_name').should be_success
  end

  it "successfully parses nonterminal names that begin with reserved words" do
    @parser.parse('rule_name').should be_success
    @parser.parse('end_of_the_world').should be_success
  end
  
  it "does not parse 'rule' or 'end' as nonterminals" do
    @parser.parse('rule').should be_a_failure
    @parser.parse('end').should be_a_failure
  end
end