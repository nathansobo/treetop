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
  
  specify "returns the correct interval for a prefix starting after 0" do
    result = @terminal.parse_at("xfoo", 1, mock("Parser"))
    result.interval.should_eql 1...4
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

context "The result of TerminalSymbol#parse_at for a non-matching input prefix at a given index" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    parser = mock("Parser instance")
    input = ("barfoo")
    @result = @terminal.parse_at(input, 0, parser)
  end
  
  specify "is a kind of ParseFailure" do
    @result.should_be_a_kind_of ParseFailure
  end
  
  specify "has an index equal to the site of the attempted parse" do
    @result.index.should_equal 0
  end
end