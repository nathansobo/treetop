dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the grammar rule" do
  include MetagrammarSpecContextHelper

  before do
    set_metagrammar_root(:grammar)
    @parser = parser_for_metagrammar
  end
  
  after do
    reset_metagrammar_root
  end
  
  it "successfully parses and generates Ruby for a grammar with two rules" do
    input =
    %{grammar Foo
      rule bar
        'baz'
      end
      rule boo
        'bip'
      end
    end}
    
    result = @parser.parse(input)
    result.should be_success
    
    eval(result.to_ruby)
    
    Foo.should be_an_instance_of(Grammar)
    Foo.get_parsing_expression(Foo.nonterminal_symbol(:bar)).should be_an_instance_of(TerminalSymbol)
    Foo.get_parsing_expression(Foo.nonterminal_symbol(:boo)).should be_an_instance_of(TerminalSymbol)
    
    teardown_grammar_constant(:Foo)
  end
end