require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
  
context "One-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
  end
  
  specify "fails when parsing epsilon" do
    index = 0
    epsilon = ""
    result = @one_or_more.parse_at(epsilon, index, mock("Parser"))
    result.should_be_failure
    result.index.should_equal index
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    (result.elements.collect {|e| e.text_value }).should_eql [@terminal.prefix]
    result.interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal (index + (@terminal.prefix.size * 5))
  end
  
  specify "has a string representation" do
    @one_or_more.to_s.should == '("foo")+'
  end
end


context "One-or-more of a terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = ZeroOrMore.new(@terminal)
    @one_or_more.node_class_eval do
      def method
      end
    end
  end
  
  specify "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_respond_to :method
  end
  
  specify "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, mock("Parser"))
    result.should_respond_to :method
  end
end