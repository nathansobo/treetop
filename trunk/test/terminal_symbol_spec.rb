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
    
    result = @terminal.parse_at("---foo", 3, mock("Parser"))
    result.interval.should_eql 3...6
  end
end

context "The result of TerminalSymbol#parse_at for a matching input prefix at a given index" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    parser = mock("Parser instance")
    input = ("foobar")
    @result = @terminal.parse_at(input, 0, parser)
  end
  
  specify "is successful" do
    @result.should_be_success
  end
  
  specify "has a text value matching the terminal symbol" do
    @result.text_value.should_eql @terminal.prefix
  end
  
  specify "is a kind of TerminalSyntaxNode" do
    @result.should_be_a_kind_of TerminalSyntaxNode
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

context "A terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @terminal.node_class_eval do
      def method
      end
    end
  end
  
  specify "returns nodes that have that method on a successful parse" do
    input = @terminal.prefix
    index = 0
    parser = mock("parser")
    
    result = @terminal.parse_at(input, index, parser)
    result.should_be_success
    result.should_respond_to :method
  end
end