require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "Zero-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @zero_or_more = ZeroOrMore.new(@terminal)
  end
  
  specify "returns an empty SequenceSyntaxNode when parsing epsilon without advancing the index" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    result.should_be_empty
    result.interval.end.should_equal index
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    (result.elements.collect {|e| e.text_value }).should_eql [@terminal.prefix]
    result.interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
end