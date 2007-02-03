require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A grammar for treetop grammars" do
  setup do
    @grammar = Metagrammar.new
    @parser = @grammar.new_parser
  end
  
  specify "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    @grammar.root = @grammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    @grammar.root = @grammar.nonterminal_symbol(:terminal_symbol)
    terminal = @parser.parse('"foo"').value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a bracketed string as a CharacterClass" do
    @grammar.root = @grammar.nonterminal_symbol(:character_class)
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
    @grammar.root = @grammar.nonterminal_symbol(:anything_symbol)
    char_class = @parser.parse('.').value
    char_class.should_be_an_instance_of AnythingSymbol
  end
  
  specify "parses an unquoted string as a NonterminalSymbol and installs it in the grammar passed to value on the resulting syntax node" do
    @grammar.root = @grammar.nonterminal_symbol(:nonterminal_symbol)
    syntax_node = @parser.parse('foo')    

    grammar = Grammar.new
    nonterminal = syntax_node.value(grammar)
    nonterminal.should_be_an_instance_of NonterminalSymbol
    nonterminal.name.should_equal :foo
    grammar.nonterminal_symbol(:foo).should_equal(nonterminal)
  end
end