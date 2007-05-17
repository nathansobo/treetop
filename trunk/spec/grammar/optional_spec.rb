require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An optional terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @optional = Optional.new(@terminal)
  end
  
  specify "returns a SuccessfulParseResult with empty terminal node as its value on parsing epsilon" do
    epsilon = ""
    result = @optional.parse_at(epsilon, 0, parser_with_empty_cache_mock)
    result.should be_success
    result.should be_a_kind_of(TerminalSyntaxNode)
    result.should be_epsilon
  end
  
  specify "returns a SuccessfulParseResult with a terminal node matching the terminal symbol on parsing matching input" do
    result = @optional.parse_at(@terminal.prefix, 0, parser_with_empty_cache_mock)
    result.should be_success
    result.should be_a_kind_of(TerminalSyntaxNode)
    result.text_value.should eql @terminal.prefix
  end
  
  specify "has a string representation" do
    @optional.to_s.should == '("foo")?'
  end
end