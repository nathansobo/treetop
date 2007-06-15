dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the nonterminal_symbol rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :nonterminal_symbol
  end

  it "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    with_protometagrammar(@root) do |parser|
      syntax_node = parser.parse('foo')    

      grammar = Grammar.new
      nonterminal = syntax_node.value(grammar)
      nonterminal.should be_an_instance_of(NonterminalSymbol)
      nonterminal.name.should == :foo
      grammar.nonterminal_symbol(:foo).should == nonterminal
    end
  end
  
  it "parses unquoted strings with underscores successfully" do
    with_protometagrammar(@root) do |parser|
      parser.parse('underscore_rule_name').should be_success
    end
  end

  it "parses nonterminal names that begin with reserved words successfully" do
    with_protometagrammar(@root) do |parser|
      parser.parse('rule_name').should be_success
      parser.parse('end_of_the_world').should be_success      
    end
  end
  
  it "does not parse 'rule' or 'end' as nonterminals" do
    with_protometagrammar(@root) do |parser|    
      parser.parse('rule').should be_a_failure
      parser.parse('end').should be_a_failure
    end
  end
end