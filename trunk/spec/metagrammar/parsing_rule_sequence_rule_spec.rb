dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "In the Metagrammar only, the node returned by the parsing_rule_sequence rule's successful parsing of two parsing rules" do
  include MetagrammarSpecContextHelper
  
  before do
    Bar = Grammar.new
    with_metagrammar(:parsing_rule_sequence) do |parser|
      input =
      %{rule foo
          'bar'
        end
      
        rule baz
          'bot'
        end}
      
      @node = parser.parse(input)
    end
  end
  
  after do
    Object.send(:remove_const, :Bar)
  end
  
  it "has a Ruby source representation that adds all rules to a grammar" do
    @node.to_ruby(grammar_node_mock('Foo')).should == "Foo.add_parsing_rule(ParsingRule.new(Foo.nonterminal_symbol(:foo), TerminalSymbol.new('bar')))\nFoo.add_parsing_rule(ParsingRule.new(Foo.nonterminal_symbol(:baz), TerminalSymbol.new('bot')))\n"
  end
end

describe "In the Metagrammar only, the node returned by the parsing_rule_sequence rule's successful parsing of epsilon" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:parsing_rule_sequence) do |parser|
      @node = parser.parse('')
    end
  end
  
  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock).should == ''
  end
end