dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the sequence rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :sequence
  end

  it "parses a series of space-separated terminals and nonterminals as a sequence" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      syntax_node = parser.parse('"terminal" nonterminal1 nonterminal2')
      syntax_node.should be_success  

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.elements[0].should be_an_instance_of(TerminalSymbol)
      sequence.elements[0].prefix.should == "terminal"
      sequence.elements[1].should be_an_instance_of(NonterminalSymbol)
      sequence.elements[1].name.should == :nonterminal1
      sequence.elements[2].should be_an_instance_of(NonterminalSymbol)
      sequence.elements[2].name.should == :nonterminal2
    end
  end
  
  it "parses a series of space-separated non-terminals as a sequence" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      syntax_node = parser.parse('a b c')

      grammar = Grammar.new
      sequence = syntax_node.value(grammar)
      sequence.should be_an_instance_of(Sequence)
    end
  end
  
  it "node class evaluates a block following a sequence in the parsing expression for that sequence" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("a b c {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.node_class.instance_methods.should include('a_method')      
    end
  end
  
  it "binds trailing blocks more tightly to terminal symbols than sequences" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("a b 'c' {\n  def a_method\n  end\n}")
      result.should be_success
    
      grammar = Grammar.new
      sequence = result.value(grammar)
      sequence.should be_an_instance_of(Sequence)
      sequence.node_class.instance_methods.should_not include('a_method')
      sequence.elements[2].node_class.instance_methods.should include('a_method')      
    end
  end
end

describe "In the Metagrammar only, the node returned by the sequence rule's successful parsing of space-separated terminals" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("'foo' 'bar' 'baz'")
    end
  end
  
  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock).should == "Sequence.new([TerminalSymbol.new('foo'), TerminalSymbol.new('bar'), TerminalSymbol.new('baz')])"
  end
end

describe "In the Metagrammar only, the node returned by the sequence rule's successful parsing of space-separated terminals and nonterminals" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("'foo' bar baz")
    end
  end
  
  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock('Foo')).should == "Sequence.new([TerminalSymbol.new('foo'), Foo.nonterminal_symbol(:bar), Foo.nonterminal_symbol(:baz)])"
  end
end

describe "In the Metagrammar only, a sequence followed by a block" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:sequence) do |parser|
      @node = parser.parse("foo bar {\ndef a_method\n\nend\n}")
    end
  end
  
  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock('Foo')).should == "Sequence.new([Foo.nonterminal_symbol(:foo), Foo.nonterminal_symbol(:bar)]) do\ndef a_method\n\nend\nend"
  end

end