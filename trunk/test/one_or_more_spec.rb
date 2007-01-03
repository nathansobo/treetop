require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"
  
context "One-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
  end
  
  specify "returns a ParseFailure when parsing epsilon" do
    index = 0
    epsilon = ""
    result = @one_or_more.parse_at(epsilon, index, mock("Parser"))
    result.should_be_an_instance_of ParseFailure
    result.index.should_equal index
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    (result.elements.collect {|e| e.text_value }).should_eql [@terminal.prefix]
    result.interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
end