dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the grammar rule's successful parsing of a grammar with no rules" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:grammar) do |parser|
      @node = parser.parse %{grammar Foo end}
    end
  end
  
  after do
    Object.instance_eval do
      remove_const(:Foo) if const_defined?(:Foo)
    end
  end
  
  it "has a Ruby source representation that creates that grammar when evaluated" do
    eval(@node.to_ruby)
    Foo.should be_an_instance_of(Grammar)
    Foo.name.should == 'Foo'
  end
end

describe "The node returned by the grammar rule's successful parsing of a grammar with a single rule" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:grammar) do |parser|
      input =
      %{grammar Foo
        rule bar
          'baz'
        end
        rule boo
          'bip'
        end
      end}
      @node = parser.parse(input)
    end
  end
  
  it "has a Ruby source representation that creates a grammar with that rule when evaluated" do
    eval(@node.to_ruby)
    Foo.should be_an_instance_of(Grammar)
    Foo.name.should == 'Foo'
    Foo.get_parsing_expression(Foo.nonterminal_symbol(:bar)).should be_an_instance_of(TerminalSymbol)
    Foo.get_parsing_expression(Foo.nonterminal_symbol(:boo)).should be_an_instance_of(TerminalSymbol)
  end
end

