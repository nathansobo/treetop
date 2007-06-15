dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the parsing_rule rule's successful parsing of a rule with a terminal expression" do
  include MetagrammarSpecContextHelper

  before do
    Bar = Grammar.new
    with_metagrammar(:parsing_rule) do |parser|
      @node = parser.parse("rule foo 'bar' end")
    end
  end
  
  after do
    Object.send(:remove_const, :Bar)
  end

  it "has a Ruby source representation that evaluates to a ParsingRule referring to the expression" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    value.should be_an_instance_of(ParsingRule)
    value.nonterminal_symbol.name.should == :foo
    value.parsing_expression.prefix.should == 'bar'
  end
  
  it 'can generate Ruby that adds it to a grammar when evaluated' do
    eval(@node.add_rule_ruby(grammar_node_mock('Bar')))
    Bar.get_parsing_expression(Bar.nonterminal_symbol(:foo)).prefix.should == 'bar'
  end
end