dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the primary rule" do
  include MetagrammarSpecContextHelper

  before do
    @root = :primary
  end

  it "parses an expression followed immediately by a + as one or more of that expression" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, '"b"+')
      result.should be_an_instance_of(OneOrMore)      
    end
  end

  it "parses a nonterminal, string terminal, anything character, or character class" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      grammar = Grammar.new

      parser.parse("'foo'").value(grammar).should be_an_instance_of(TerminalSymbol)
      parser.parse('foo').value(grammar).should be_an_instance_of(NonterminalSymbol)
      parser.parse('.').value(grammar).should be_an_instance_of(AnythingSymbol)
      parser.parse('[abc]').value(grammar).should be_an_instance_of(CharacterClass)      
    end
  end

  it "parses an &-predication" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, '&"foo"')

      result.should be_instance_of(AndPredicate)      
    end
  end

  it "parses a !-predication" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, '!"foo"')

      result.should be_instance_of(NotPredicate)      
    end
  end

  it "parses suffixes with higher precedence than prefixes" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parse_result_for(parser, '!"foo"+')

      result.should be_instance_of(NotPredicate)
      result.expression.should be_instance_of(OneOrMore)      
    end
  end
  
  it "parses a parenthesized terminal symbol followed by a block with the block bound to that terminal" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("( 'foo' ) {\n  def a_method\n  end\n}")
      result.should be_success
    
      terminal = result.value(Grammar.new)
      terminal.should be_instance_of(TerminalSymbol)
      terminal.node_class.instance_methods.should include('a_method')      
    end
  end
  
  it "parses a parenthesized sequence ending in a terminal symbol followed by a block with the block bound to that sequence" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("( 'foo' 'bar' 'baz' ) {\n  def a_method\n  end\n}")
      result.should be_success
    
      sequence = result.value(Grammar.new)
      sequence.should be_instance_of(Sequence)
      sequence.node_class.instance_methods.should include('a_method')      
    end
  end
  
  it "raises when a block follows a non-node-instantiating parenthesized expression is followed by a block" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("( 'foo' / 'bar' / 'baz' ) {\n  def a_method\n  end\n}")
    
      lambda do
        result.value(Grammar.new)
      end.should raise_error(RuntimeError)
    end
  end
end


describe "In only the Metagrammar, the node returned by the primary rule's successful parsing of a terminal symbol followed by a +" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('"b"+')
    end
  end

  it "has a Ruby source representiation" do
    @node.to_ruby(grammar_node_mock).should == 'OneOrMore.new(TerminalSymbol.new("b"))'
  end
end

describe "In only the Metagrammar, the node returned by the primary rule's successful parsing of a terminal symbol" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('"foo"')
    end
  end

  it "has a Ruby source representiation" do
    @node.to_ruby(grammar_node_mock).should == 'TerminalSymbol.new("foo")'
  end
end

describe "In only the Metagrammar, the node returned by the primary rule's successful parse of a terminal symbol preceded by an &" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("&'foo'")
    end
  end
    
  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock).should == "AndPredicate.new(TerminalSymbol.new('foo'))"
  end
end


describe "In only the Metagrammar, the node returned by the primary rule's successful parse of a terminal symbol preceded by a ! and followed by a +" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse("!'foo'+")
    end
  end

  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock).should == "NotPredicate.new(OneOrMore.new(TerminalSymbol.new('foo')))"
  end
end

describe "In only the Metagrammar, the node returned by the primary rule's successful parsing of a nonterminal symbol" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:primary) do |parser|
      @node = parser.parse('foo')
    end
  end

  it "has a Ruby source representation given a named grammar in which the symbol is referenced" do
    @node.to_ruby(grammar_node_mock('Bar')).should == "Bar.nonterminal_symbol(:foo)"
  end
end