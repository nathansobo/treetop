dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the primary rule" do
  include MetagrammarSpecContextHelper

  before do
    @root = :primary
  end

  it "parses a nonterminal, string terminal, anything character, or character class" do
    with_metagrammar(@root) do |parser|
      grammar = Grammar.new

      parser.parse("'foo'").should be_success
      parser.parse('foo').should be_success
      parser.parse('.').should be_success
      parser.parse('[abc]').should be_success
    end
  end
end


describe "The node returned by the primary rule's successful parsing of a parenthesized sequence ending in a terminal followed by a block" do
  include MetagrammarSpecContextHelper
  
  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("( 'foo' 'bar' 'baz' ) {\n  def a_method\n  end\n}")
    end
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to the sequence with the method from the block defined in its node class" do
    value = eval(@node.to_ruby(grammar_node_mock('Foo')))
    value.should be_an_instance_of(Sequence)
    value.node_class.instance_methods.should include('a_method')
  end
end


describe "The node returned by the primary rule's successful parsing of a parenthesized terminal followed by a block" do
  include MetagrammarSpecContextHelper
  
  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("( 'foo' ) {\n  def a_method\n  end\n}")
    end
  end
  
  it "is successful" do
    @node.should be_success
  end
  
  it "has a Ruby source representation that evaluates to the terminal symbol with the method from the block defined in its node class" do
    value = eval(@node.to_ruby(grammar_node_mock('Foo')))
    value.should be_an_instance_of(TerminalSymbol)
    value.node_class.instance_methods.should include('a_method')
  end
end

describe "The node returned by the primary rule's successful parsing of a terminal symbol followed by a +" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('"b"+')
    end
  end
  
  it "is successful" do
    @node.should be_success
  end

  it "has a Ruby source representiation that evaluates to an expression that can parse one or more of that terminal" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.parse_at('bbb', 0, parser_with_empty_cache_mock).should be_success
  end
end

describe "The node returned by the primary rule's successful parsing of a terminal symbol" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('"foo"')
    end
  end

  it "is successful" do
    @node.should be_success
  end

  it "has a Ruby source representiation that evaluates to a terminal with the correct prefix" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(TerminalSymbol)
    value.prefix.should == 'foo'
  end
end

describe "The node returned by the primary rule's successful parse of a terminal symbol preceded by an &" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("&'foo'")
    end
  end

  it "is successful" do
    @node.should be_success
  end
    
  it "has a Ruby source representation that evaluates to an AndPredicate containing the nested terminal" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(AndPredicate)
    value.expression.should be_an_instance_of(TerminalSymbol)
  end
end

describe "The node returned by the primary rule's successful parse of a terminal symbol preceded by a ! and followed by a +" do
  include MetagrammarSpecContextHelper

  before(:all) do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("!'foo'+")
    end
  end

  it "is successful" do
    @node.should be_success
  end

  it "has a Ruby source representation that evaluates to the not predication of one or more of the symbol, reflecting the correct precedence of the two operators" do
    value = eval(@node.to_ruby(grammar_node_mock))
    value.should be_an_instance_of(NotPredicate)
    value.expression.should be_an_instance_of(OneOrMore)
  end
end

describe "The node returned by the primary rule's successful parsing of a nonterminal symbol" do
  include MetagrammarSpecContextHelper

  before(:all) do
    Bar = Grammar.new
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('foo')
    end
  end
  
  after(:all) do
    Object.send(:remove_const, :Bar)
  end

  it "is successful" do
    @node.should be_success
  end

  it "has a Ruby source representation that evaluates to the nonterminal in the containing grammar" do
    value = eval(@node.to_ruby(grammar_node_mock('Bar')))
    value.should == Bar.nonterminal_symbol(:foo)
  end
end