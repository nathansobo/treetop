dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the metagrammar and protometagrammar rooted at the terminal_symbol rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :terminal_symbol
  end
  
  it "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    with_protometagrammar(@root) do |parser|
      terminal = parser.parse("'foo'").value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.prefix.should == 'foo'
    end
  end
  
  it "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    with_protometagrammar(@root) do |parser|
      terminal = parser.parse('"foo"').value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.prefix.should == 'foo'      
    end
  end
  
  it "parses a terminal symbol followed by a Ruby block" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse("'foo' {\ndef a_method\n\nend\n}")
      result.should be_success
      
      terminal = result.value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.parse_at('foo', 0, parser_with_empty_cache_mock).should respond_to(:a_method)
    end
  end
end

