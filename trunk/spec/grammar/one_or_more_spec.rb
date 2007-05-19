require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
  
describe "One-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
  end
  
  it "fails when parsing epsilon with a nested failure" do
    index = 0
    epsilon = ""
    result = @one_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(ParseFailure)
    result.interval.should == (index...index)

    result.nested_failures.size.should == 1
    result.nested_failures.first.expression.should == @terminal
  end
  
  it "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)

    result.should be_success
    result.interval.end.should == index + @terminal.prefix.size

    
    result.should be_a_kind_of(SequenceSyntaxNode)
    (result.elements.collect {|e| e.text_value }).should == [@terminal.prefix]
  end
  
  it "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success
    

    result.should be_a_kind_of(SequenceSyntaxNode)
    result.elements.size.should == 5
    result.interval.end.should == (index + (@terminal.prefix.size * 5))
  end
  
  it "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success
  
    result.should be_a_kind_of(SequenceSyntaxNode)
    result.elements.size.should == 5
    result.interval.end.should == (index + (@terminal.prefix.size * 5))
  end
  
  it "has a string representation" do
    @one_or_more.to_s.should == '("foo")+'
  end
end


describe "One-or-more of a terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
    @one_or_more.node_class_eval do
      def method
      end
    end
  end
  
  it "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should respond_to(:method)
  end
  
  it "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should respond_to(:method)
  end
end

describe "The result of one or more of an expression that parses successfully with nested failures twice and then fails, when the nested failure of the second result has the highest index of all failures encountered" do
  before(:each) do
    @expression = mock('parsing expression')
    
    @result_1 = parse_success_with_nested_failure_at(2)
    @result_2 = parse_success_with_nested_failure_at(5)
    @result_3 = parse_failure_at(4)
    
    @expression.stub!(:parse_at).and_return(@result_1, @result_2, @result_3)
    
    @one_or_more = OneOrMore.new(@expression)
    
    @result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  it "has the nested failure of encountered results with the highest index as its only nested failure" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 1
    nested_failures.should include(@result_2.nested_failures.first)
  end
end

describe "The result of one or more of an expression that fails on the first parsing attempt with nested failures" do
  before(:each) do
    @expression = mock('parsing expression')
    @child_result = parse_failure_at_with_nested_failure_at(0, 4)
    @expression.stub!(:parse_at).and_return(@child_result)
    @one_or_more = OneOrMore.new(@expression)
    @result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end

  it "is a failure" do
    @result.should be_failure
  end
  
  it "has the nested failure on the encountered failure as its nested failure" do
    @result.nested_failures.should include(@child_result.nested_failures.first)
  end
end