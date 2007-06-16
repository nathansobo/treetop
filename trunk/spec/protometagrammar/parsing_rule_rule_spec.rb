dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the Protometagrammar rooted at the parsing_rule rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :parsing_rule
  end

  it "parses a parse rule with a terminal symbol as its expression" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, "rule foo 'bar' end")
   
      result.should be_an_instance_of(ParsingRule)
      result.nonterminal_symbol.name.should == :foo
      result.parsing_expression.should be_an_instance_of(TerminalSymbol)
    end
  end
  
  it "parses a parse rule with a complex expression" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, "rule foo 'bar' baz+ (xyzzy / plugh*) !bar end")
   
      result.should be_an_instance_of(ParsingRule)
    end
  end
end