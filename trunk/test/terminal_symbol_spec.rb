require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
  end
  
  specify "is a kind of AtomicParsingExpression" do
    @terminal.should_be_a_kind_of AtomicParsingExpression
  end
end

context "The result of TerminalSymbol#parse_at for a matching input prefix at a given index" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    parser = mock("Parser instance")
    input = ("foobar")
    @result = @terminal.parse_at(input, 0, parser)
  end
  
  specify "is a kind of SyntaxNode" do
    @result.should_be_a_kind_of SyntaxNode
  end
  
  specify "has a text value matching the terminal symbol" do
    @result.text_value.should_eql @terminal.prefix
  end
end


