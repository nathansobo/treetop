require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"


context "The subset of the metagrammar rooted at the terminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:terminal_symbol)
  end
  
  specify "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    terminal = @parser.parse("'foo'").value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    terminal = @parser.parse('"foo"').value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.prefix.should_eql 'foo'
  end
  
  specify "parses a terminal symbol followed by a node class eval block" do
    result = @parser.parse("'foo' {\ndef a_method\n\nend\n}")
    result.should be_success
    terminal = result.value
    terminal.should_be_an_instance_of TerminalSymbol
    terminal.node_class.instance_methods.should include('a_method')
  end
end