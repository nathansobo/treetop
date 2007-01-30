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