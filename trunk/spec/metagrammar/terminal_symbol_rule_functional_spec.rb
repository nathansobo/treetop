dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar and protometagrammar rooted at the terminal_symbol rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :terminal_symbol
  end
  
  it "parses a single-quoted string as a TerminalSymbol with the correct prefix value" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      terminal = parser.parse("'foo'").value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.prefix.should == 'foo'
    end
  end
  
  it "parses a double-quoted string as a TerminalSymbol with the correct prefix value" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      terminal = parser.parse('"foo"').value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.prefix.should == 'foo'      
    end
  end
  
  it "parses a terminal symbol followed by a Ruby block" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse("'foo' {\ndef a_method\n\nend\n}")
      result.should be_success
      
      terminal = result.value
      terminal.should be_an_instance_of(TerminalSymbol)
      terminal.parse_at('foo', 0, parser_with_empty_cache_mock).should respond_to(:a_method)
    end
  end
end

describe "The node returned by the terminal_symbol rule's successful parsing of a single-quoted string" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:terminal_symbol) do |parser|
      @node = parser.parse("'foo'")
    end
  end

  it "can generate Ruby to construct a TerminalSymbol" do
    @node.to_ruby.should == "TerminalSymbol.new('foo')"
  end
end

describe "The node returned by the terminal_symbol rule's successful parsing of a single-quoted string followed by a Ruby block" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:terminal_symbol) do |parser|
      @node = parser.parse("'foo' {\ndef a_method\n\nend\n}")
    end
  end

  it "can generate Ruby to construct a TerminalSymbol that evaluates the trailing block in its node class" do
    @node.to_ruby.should == "TerminalSymbol.new('foo') do\ndef a_method\n\nend\nend"
  end
end

describe "The node returned by the terminal_symbol rule's successful parsing of a double-quoted string" do
  include MetagrammarSpecContextHelper

  before do
    with_metagrammar(:terminal_symbol) do |parser|
      @node = parser.parse('"foo"')
    end
  end

  it "can generate Ruby to construct a TerminalSymbol" do
    @node.to_ruby.should == "TerminalSymbol.new('foo')"
  end
end

describe "The node returned by the terminal_symbol rule's successful parsing of a double-quoted string followed by a Ruby block" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:terminal_symbol) do |parser|
      @node = parser.parse("\"foo\" {\ndef a_method\n\nend\n}")
    end
  end

  it "can generate Ruby to construct a TerminalSymbol that evaluates the trailing block in its node class" do
    @node.to_ruby.should == "TerminalSymbol.new('foo') do\ndef a_method\n\nend\nend"
  end
end
