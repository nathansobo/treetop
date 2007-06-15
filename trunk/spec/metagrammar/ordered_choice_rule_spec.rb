dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the ordered_choice rule" do
  include MetagrammarSpecContextHelper
  
  before do
    Bar = Grammar.new
    @root = :ordered_choice
  end
  
  after do
    Object.send(:remove_const, :Bar)
  end
  
  it "parses sequences with higher precedence than ordered choices" do
    with_metagrammar(@root) do |parser|
      result = eval(parser.parse('a b / c d').to_ruby(grammar_node_mock('Bar')))
      
      result.should be_an_instance_of(OrderedChoice)
      result.alternatives[0].should be_an_instance_of(Sequence)
      result.alternatives[1].should be_an_instance_of(Sequence)          
    end
  end
  
  it "parses expressions in parentheses as themselves" do        
    with_metagrammar(@root) do |parser|
      parse_result_for(parser, 'Bar', "('foo')").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', '("foo")').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', '(foo)').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, 'Bar', '(.)').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, 'Bar', '([abc])').should be_an_instance_of(CharacterClass)
      parse_result_for(parser, 'Bar', '("terminal" / nonterminal1 / nonterminal2)').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', '(a b / c d)').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', '("terminal" nonterminal1 nonterminal2)').should be_an_instance_of(Sequence)
    end
  end

  it "parses expressions in parentheses with extra spaces as themselves" do        
    with_metagrammar(@root) do |parser|
      parse_result_for(parser, 'Bar', "( 'foo' )").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', '( "foo" )').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', '( foo  )').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, 'Bar', '(  .  )').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, 'Bar', '( [abc] )').should be_an_instance_of(CharacterClass)
      parse_result_for(parser, 'Bar', '(   "terminal" / nonterminal1 / nonterminal2  )').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', '( a b / c d  )').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', '(  "terminal" nonterminal1 nonterminal2  )').should be_an_instance_of(Sequence)      
    end
  end

  it "allows parentheses to override default precedence rules" do
    with_metagrammar(@root) do |parser|
      result = parse_result_for(parser, 'Bar', '(a / b) (c / d)')
      result.should be_an_instance_of(Sequence)
    
      result.elements[0].should be_an_instance_of(OrderedChoice)
      result.elements[1].should be_an_instance_of(OrderedChoice)          
    end
  end

  it "allows nested parentheses to control precedence" do
    with_metagrammar(@root) do |parser|
      result = parse_result_for(parser, 'Bar', '(a / ((ba / bb) (bc / bd))) (c / d)')
      result.should be_an_instance_of(Sequence)
    
      first_element = result.elements[0]
      first_element.should be_an_instance_of(OrderedChoice)
      first_element.alternatives[0].should be_an_instance_of(NonterminalSymbol)
    
      nested_sequence = first_element.alternatives[1]
      nested_sequence.should be_an_instance_of(Sequence)
    
      nested_sequence.elements[0].should be_an_instance_of(OrderedChoice)
      nested_sequence.elements[1].should be_an_instance_of(OrderedChoice)      
    end
  end
  
  it "parses an expression followed immediately by a * as zero or more of that expression" do    
    with_metagrammar(@root) do |parser|
      result = parse_result_for(parser, 'Bar', '"b"*')
      result.should be_an_instance_of(ZeroOrMore)      
    end
  end
  
  it "parses any kind of parsing expression with the ordered choice rule" do
    with_metagrammar(@root) do |parser|
      parse_result_for(parser, 'Bar', '"terminal" / nonterminal1 / nonterminal2').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', 'a b / c d').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'Bar', '"terminal" nonterminal1 nonterminal2').should be_an_instance_of(Sequence)
      parse_result_for(parser, 'Bar', "'foo'").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', '"foo"').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'Bar', 'foo').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, 'Bar', '.').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, 'Bar', '[abc]').should be_an_instance_of(CharacterClass)      
    end
  end

  it "parses an expression followed immediately by a ? as an optional expression" do
    with_metagrammar(@root) do |parser|
      result = parse_result_for(parser, 'Bar', '"b"?')
      result.should be_an_instance_of(Optional)      
    end
  end

  it "parses a series of / separated terminals and nonterminals as an ordered choice" do
    with_metagrammar(@root) do |parser|
      syntax_node = parser.parse('"terminal" / nonterminal1 / nonterminal2')

      grammar = Grammar.new
      choice = eval(syntax_node.to_ruby(grammar_node_mock('Bar')))
      choice.should be_an_instance_of(OrderedChoice)
      choice.alternatives[0].should be_an_instance_of(TerminalSymbol)
      choice.alternatives[0].prefix.should == "terminal"
      choice.alternatives[1].should be_an_instance_of(NonterminalSymbol)
      choice.alternatives[1].name.should == :nonterminal1
      choice.alternatives[2].should be_an_instance_of(NonterminalSymbol)
      choice.alternatives[2].name.should == :nonterminal2      
    end
  end
  
  it "parses any kind of parsing expression" do    
    with_metagrammar(@root) do |parser|
      parser.parse('"terminal" / nonterminal1 / nonterminal2').should be_success
      parser.parse('a b / c d').should  be_success
      parser.parse('"terminal" nonterminal1 nonterminal2').should be_success
      parser.parse("'foo'").should be_success
      parser.parse('"foo"').should be_success
      parser.parse('foo').should be_success
      parser.parse('.').should be_success
      parser.parse('[abc]').should be_success
    end
  end

  it "can parse a complex parsing expression" do
    with_metagrammar(@root) do |parser|      
      parser.parse("'foo' bar !(a / b &x+)+").should be_a_success
    end
  end
  
  it "parses expressions separated by / and no space as an ordered choice" do
    with_metagrammar(@root) do |parser|
      result = parser.parse('a/b/(c/d)')
      result.should be_success
      eval(result.to_ruby(grammar_node_mock('Bar'))).should be_an_instance_of(OrderedChoice)      
    end
  end
end

describe "In the Metagrammar only, the node returned by the ordered_choice rule's successful parsing of an ordered choice between a terminal and a nonterminal" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:ordered_choice) do |parser|
      @node = parser.parse("'foo' / bar")
    end
  end

  it "has a Ruby source representation" do
    @node.to_ruby(grammar_node_mock('Foo')).should == "OrderedChoice.new([TerminalSymbol.new('foo'), Foo.nonterminal_symbol(:bar)])"
  end
end
