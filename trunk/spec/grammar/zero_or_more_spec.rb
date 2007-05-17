require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "Zero-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @zero_or_more = ZeroOrMore.new(@terminal)
  end
  
  it "returns an empty kind of SequenceSyntaxNode when parsing epsilon without advancing the index" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    
    result.should be_success
    result.interval.end.should == index
    
    result.should be_a_kind_of(SequenceSyntaxNode)
    result.should be_empty
  end
  
  it "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success

    result.should be_a_kind_of(SequenceSyntaxNode)
    result.elements.size.should == 1
    result.elements.first.text_value.should == @terminal.prefix
    result.interval.end.should == index + @terminal.prefix.size
  end
  
  it "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    
    result.should be_success
    result.should be_a_kind_of(SequenceSyntaxNode)
    result.elements.size.should == 5
    result.interval.end.should == (index + (@terminal.prefix.size * 5))
  end
  
  it "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success
    

    result.should be_a_kind_of(SequenceSyntaxNode)
    result.elements.size.should == 5
    result.interval.end.should equal(index + (@terminal.prefix.size * 5))
  end
  
  it "has a string representation" do
    @zero_or_more.to_s.should == '("foo")*'
  end
end

describe "Zero-or-more of a terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @zero_or_more = ZeroOrMore.new(@terminal)
    @zero_or_more.node_class_eval do
      def a_method
        'foo'
      end
    end
  end
  
  it "returns a node that has that method upon a successful parse of epsilon" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    
    result.should be_success
    result.should respond_to(:a_method)
  end
  
  it "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should respond_to(:a_method)
  end
  
  it "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should respond_to(:a_method)
  end
end