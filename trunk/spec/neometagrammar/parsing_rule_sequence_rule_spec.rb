dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the parsing_rule_sequence rule" do
  include NeometagrammarSpecContextHelper

  before do
    set_metagrammar_root(:parsing_rule_sequence)
    @parser = parser_for_metagrammar
    @grammar_node_mock = setup_grammar_constant(:Bar)
  end
  
  after do
    reset_metagrammar_root
    teardown_grammar_constant(:Bar)
  end

  it "successfully parses and generates Ruby for a sequence of two parsing rules" do
    input =
    %{rule foo
        'bar'
      end
    
      rule baz
        'bot'
      end}
    
    result = @parser.parse(input)
    
    result.should be_success
    eval(result.to_ruby(@grammar_node_mock))
    
    Bar.get_parsing_expression(Bar.nonterminal_symbol(:foo)).prefix.should == 'bar'
    Bar.get_parsing_expression(Bar.nonterminal_symbol(:baz)).prefix.should == 'bot'
  end
  
  it "succesfully parses epsilon" do
    @parser.parse('').should be_success
  end
end