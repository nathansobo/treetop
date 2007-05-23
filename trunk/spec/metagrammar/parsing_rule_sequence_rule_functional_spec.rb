dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the parsing_rule_sequence rule" do
  include MetagrammarSpecContextHelper

  before do
    @root = :parsing_rule_sequence
    @metagrammar = Protometagrammar.new
    parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:parsing_rule_sequence)
  end
  
  it "parses a single rule" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      input = "rule foo bar end"
    
      result = parser.parse(input)
      result.should be_success      
      
      grammar = Grammar.new
      rules = result.value(grammar)
      
      rules[0].should be_an_instance_of(ParsingRule)
    end
  end
  
  it "parses two rules" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      input = "rule foo bar end rule baz bop end"
    
      result = parser.parse(input)
      result.should be_success
      
      grammar = Grammar.new
      rules = result.value(grammar)
      
      rules.each do |rule|
        rule.should be_an_instance_of(ParsingRule)
      end
    end
  end
  
  it "parses a parse rule with newlines in it" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      input = 
      %{rule foo
          bar
        end}

      result = parser.parse(input)
      result.should be_success
    end
  end
end