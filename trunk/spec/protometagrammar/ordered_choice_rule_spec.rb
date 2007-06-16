dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the metagrammar rooted at the ordered_choice rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :ordered_choice
  end
  
  it "parses sequences with higher precedence than ordered choices" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, 'a b / c d')
      result.should be_an_instance_of(OrderedChoice)
      result.alternatives[0].should be_an_instance_of(Sequence)
      result.alternatives[1].should be_an_instance_of(Sequence)          
    end
  end
  
  it "parses expressions in parentheses as themselves" do        
    with_protometagrammar(@root) do |parser|
      parse_result_for(parser, "('foo')").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '("foo")').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '(foo)').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, '(.)').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, '([abc])').should be_an_instance_of(CharacterClass)
      parse_result_for(parser, '("terminal" / nonterminal1 / nonterminal2)').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '(a b / c d)').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '("terminal" nonterminal1 nonterminal2)').should be_an_instance_of(Sequence)
    end
  end

  it "parses expressions in parentheses with extra spaces as themselves" do        
    with_protometagrammar(@root) do |parser|
      parse_result_for(parser, "( 'foo' )").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '( "foo" )').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '( foo  )').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, '(  .  )').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, '( [abc] )').should be_an_instance_of(CharacterClass)
      parse_result_for(parser, '(   "terminal" / nonterminal1 / nonterminal2  )').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '( a b / c d  )').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '(  "terminal" nonterminal1 nonterminal2  )').should be_an_instance_of(Sequence)      
    end
  end

  it "allows parentheses to override default precedence rules" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, '(a / b) (c / d)')
      result.should be_an_instance_of(Sequence)
    
      result.elements[0].should be_an_instance_of(OrderedChoice)
      result.elements[1].should be_an_instance_of(OrderedChoice)          
    end
  end

  it "allows nested parentheses to control precedence" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, '(a / ((ba / bb) (bc / bd))) (c / d)')
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
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, '"b"*')
      result.should be_an_instance_of(ZeroOrMore)      
    end
  end
  
  it "parses any kind of parsing expression with the ordered choice rule" do
    with_protometagrammar(@root) do |parser|
      parse_result_for(parser, '"terminal" / nonterminal1 / nonterminal2').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'a b / c d').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '"terminal" nonterminal1 nonterminal2').should be_an_instance_of(Sequence)
      parse_result_for(parser, "'foo'").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '"foo"').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'foo').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, '.').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, '[abc]').should be_an_instance_of(CharacterClass)      
    end
  end

  it "parses an expression followed immediately by a ? as an optional expression" do
    with_protometagrammar(@root) do |parser|
      result = parse_result_for(parser, '"b"?')
      result.should be_an_instance_of(Optional)      
    end
  end

  it "parses a series of / separated terminals and nonterminals as an ordered choice" do
    with_protometagrammar(@root) do |parser|
      syntax_node = parser.parse('"terminal" / nonterminal1 / nonterminal2')

      grammar = Grammar.new
      choice = syntax_node.value(grammar)
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
    with_protometagrammar(@root) do |parser|
      parse_result_for(parser, '"terminal" / nonterminal1 / nonterminal2').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, 'a b / c d').should be_an_instance_of(OrderedChoice)
      parse_result_for(parser, '"terminal" nonterminal1 nonterminal2').should be_an_instance_of(Sequence)
      parse_result_for(parser, "'foo'").should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, '"foo"').should be_an_instance_of(TerminalSymbol)
      parse_result_for(parser, 'foo').should be_an_instance_of(NonterminalSymbol)
      parse_result_for(parser, '.').should be_an_instance_of(AnythingSymbol)
      parse_result_for(parser, '[abc]').should be_an_instance_of(CharacterClass)      
    end
  end

  it "can parse a complex parsing expression" do
    with_protometagrammar(@root) do |parser|      
      parser.parse("'foo' bar !(a / b &x+)+").should be_a_success
    end
  end
  
  it "parses expressions separated by / and no space as an ordered choice" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse('a/b/(c/d)')
      result.should be_success
      result.value(Grammar.new).should be_an_instance_of(OrderedChoice)      
    end
  end
end

