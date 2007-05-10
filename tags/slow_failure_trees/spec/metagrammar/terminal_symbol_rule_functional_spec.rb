require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"


context "The subset of the metagrammar rooted at the terminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :terminal_symbol
  end
  
  specify "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      terminal = parser.parse("'foo'").value
      terminal.should_be_an_instance_of TerminalSymbol
      terminal.prefix.should_eql 'foo'
    end
  end
  
  specify "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      terminal = parser.parse('"foo"').value
      terminal.should_be_an_instance_of TerminalSymbol
      terminal.prefix.should_eql 'foo'      
    end
  end
  
  specify "parses a terminal symbol followed by a node class eval block" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("'foo' {\ndef a_method\n\nend\n}")
      result.should be_success
      terminal = result.value
      terminal.should_be_an_instance_of TerminalSymbol
      terminal.node_class.instance_methods.should include('a_method')      
    end
  end
end