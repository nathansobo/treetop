dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the parsing_rule rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :parsing_rule
  end

  it "parses a parse rule with a terminal symbol as its expression" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, "rule foo 'bar' end")
   
      result.should be_an_instance_of(ParsingRule)
      result.nonterminal_symbol.name.should == :foo
      result.parsing_expression.should be_an_instance_of(TerminalSymbol)      
    end
  end
  
  it "parses a parse rule with a complex expression" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, "rule foo 'bar' baz+ (xyzzy / plugh*) !bar end")
   
      result.should be_an_instance_of(ParsingRule)      
    end
  end
end

describe "In the Metagrammar only, the node returned by the parsing_rule rule's successful parsing of a rule with a terminal expression" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:parsing_rule) do |parser|
      @node = parser.parse("rule foo 'bar' end")
    end
  end

  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock('Foo')).should == "ParsingRule.new(Foo.nonterminal_symbol(:foo), TerminalSymbol.new('bar'))"
  end
end