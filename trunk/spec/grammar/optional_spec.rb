require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An optional terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @optional = Optional.new(@terminal)
  end
  
  it "returns a SuccessfulParseResult with empty terminal node as its value on parsing epsilon, with a nested failure" do
    epsilon = ""
    result = @optional.parse_at(epsilon, 0, parser_with_empty_cache_mock)
    result.should be_success
    result.should be_a_kind_of(TerminalSyntaxNode)
    result.should be_epsilon
    
    nested_failures = result.nested_failures
    nested_failures.size.should == 1
    nested_failures.first.expression.should == @terminal
  end
  
  it "returns a SuccessfulParseResult with a terminal node matching the terminal symbol on parsing matching input" do
    result = @optional.parse_at(@terminal.prefix, 0, parser_with_empty_cache_mock)
    result.should be_success
    result.should be_a_kind_of(TerminalSyntaxNode)
    result.text_value.should == @terminal.prefix
  end
  
  it "has a string representation" do
    @optional.to_s.should == '("foo")?'
  end
end