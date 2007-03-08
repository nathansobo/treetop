require 'rubygems'
require 'spec/runner'

require 'ruby-debug'
Debugger.start

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A grammar for treetop grammars" do
  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
  end

  specify "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse('"foo"').value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a bracketed string as a CharacterClass" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:character_class)
    char_class = @parser.parse('[A-C123\\]]').value
    char_class.should_be_an_instance_of CharacterClass
    
    parser = mock("parser")
    char_class.parse_at('A', 0, parser).should_be_success
    char_class.parse_at('B', 0, parser).should_be_success
    char_class.parse_at('C', 0, parser).should_be_success
    char_class.parse_at('1', 0, parser).should_be_success
    char_class.parse_at('2', 0, parser).should_be_success
    char_class.parse_at('3', 0, parser).should_be_success
    char_class.parse_at(']', 0, parser).should_be_success    
  end
  
  specify "parses . as an AnythingSymbol" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:anything_symbol)
    char_class = @parser.parse('.').value
    char_class.should_be_an_instance_of AnythingSymbol
  end
  
  specify "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:nonterminal_symbol)
    syntax_node = @parser.parse('foo')    

    grammar = Grammar.new
    nonterminal = syntax_node.value(grammar)
    nonterminal.should_be_an_instance_of NonterminalSymbol
    nonterminal.name.should_equal :foo
    grammar.nonterminal_symbol(:foo).should_equal(nonterminal)
  end
  
  specify "parses a nonterminal, string terminal, anything character, or character class with the primary parsing rule" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:primary)
    grammar = Grammar.new

    @parser.parse("'foo'").value.should_be_an_instance_of TerminalSymbol
    @parser.parse('foo').value(grammar).should_be_an_instance_of NonterminalSymbol
    @parser.parse('.').value.should_be_an_instance_of AnythingSymbol
    @parser.parse('[abc]').value(grammar).should_be_an_instance_of CharacterClass
  end
  
  specify "parses different types of whitespace with the whitespace rule" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:whitespace)
    grammar = Grammar.new

    @parser.parse(' ').should_be_success
    @parser.parse('    ').should_be_success
    @parser.parse("\t\t").should_be_success
    @parser.parse("\n").should_be_success
  end
  
  specify "does not parse nonwhitespace characters with the whitespace rule" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:whitespace)
    grammar = Grammar.new
    @parser.parse('g').should_be_failure
    @parser.parse('g ').should_be_failure  
  end
  
  specify "parses a series of space-separated terminals and nonterminals as a sequence" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:sequence)
    syntax_node = @parser.parse('"terminal" nonterminal1 nonterminal2')

    grammar = Grammar.new
    sequence = syntax_node.value(grammar)
    sequence.should_be_an_instance_of Sequence
    sequence.elements[0].should_be_an_instance_of TerminalSymbol
    sequence.elements[0].prefix.should_eql "terminal"
    sequence.elements[1].should_be_an_instance_of NonterminalSymbol
    sequence.elements[1].name.should_equal :nonterminal1
    sequence.elements[2].should_be_an_instance_of NonterminalSymbol
    sequence.elements[2].name.should_equal :nonterminal2
  end
  
  specify "parses a series of / separated terminals and nonterminals as an ordered choice" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:ordered_choice)
    syntax_node = @parser.parse('"terminal" / nonterminal1 / nonterminal2')

    grammar = Grammar.new
    choice = syntax_node.value(grammar)
    choice.should_be_an_instance_of OrderedChoice
    choice.alternatives[0].should_be_an_instance_of TerminalSymbol
    choice.alternatives[0].prefix.should_eql "terminal"
    choice.alternatives[1].should_be_an_instance_of NonterminalSymbol
    choice.alternatives[1].name.should_equal :nonterminal1
    choice.alternatives[2].should_be_an_instance_of NonterminalSymbol
    choice.alternatives[2].name.should_equal :nonterminal2
  end
  
  specify "parses any kind of parsing expression with the ordered choice rule" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:ordered_choice)
    
    assert_parses_as '"terminal" / nonterminal1 / nonterminal2', OrderedChoice
    assert_parses_as '"terminal" nonterminal1 nonterminal2', Sequence
    assert_parses_as "'foo'", TerminalSymbol
  
    assert_parses_as '"foo"', TerminalSymbol
    assert_parses_as 'foo', NonterminalSymbol
    assert_parses_as '.', AnythingSymbol
    assert_parses_as '[abc]', CharacterClass
  end

  specify "parses sequences with higher precedence than ordered choices" do
    @metagrammar.root = @metagrammar.nonterminal_symbol(:ordered_choice)
    grammar = Grammar.new
    
    value = @parser.parse(input).value(grammar)
    value.should_be_an_instance_of OrderedChoice
  end

  def assert_parses_as(input, syntax_node_subclass)
    grammar = Grammar.new
    @parser.parse(input).value(grammar).should_be_an_instance_of syntax_node_subclass
  end
end