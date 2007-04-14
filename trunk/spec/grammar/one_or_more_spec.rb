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
    result = @one_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    result.should_be_failure
    result.index.should_equal index
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_a_kind_of SequenceSyntaxNode
    (result.elements.collect {|e| e.text_value }).should_eql [@terminal.prefix]
    result.interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal(index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should == 5
    result.interval.end.should == (index + (@terminal.prefix.size * 5))
  end
  
  specify "has a string representation" do
    @one_or_more.to_s.should == '("foo")+'
  end
end


context "One-or-more of a terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
    @one_or_more.node_class_eval do
      def method
      end
    end
  end
  
  specify "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_respond_to :method
  end
  
  specify "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_respond_to :method
  end
end

context "One-or-more of a parsing expression" do
  setup do
    @embedded_expression = mock('embedded parsing expression')
    @one_or_more = OneOrMore.new(@embedded_expression)    
  end
  
  specify "returns the parse failure of that expression on the first attempted parse as a nested failure in the failure resulting therefrom" do
    failure = mock('parse failure')
    failure.stub!(:failure?).and_return(true)
    @embedded_expression.stub!(:parse_at).and_return(failure)
    
    result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should_be_failure
    result.nested_failures.should == [failure]
  end
  
  specify "returns the parse failure that terminates repeated parsing as a nested failure on the success resulting earlier successful parses" do
    success = mock('success')
    success.stub!(:failure?).and_return(false)
    success.stub!(:interval).and_return(0...5)
    success.stub!(:nested_failures).and_return([])
        
    failure = mock('parse failure')
    failure.stub!(:failure?).and_return(true)
    
    @embedded_expression.stub!(:parse_at).and_return(success, failure)
    
    result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should_be_success
    result.nested_failures.should_include failure
  end
  
  specify "includes the nested failures of any successfully parsed repeated elements in the nested failures of its result" do
    success = mock('success')
    success.stub!(:failure?).and_return(false)
    success.stub!(:interval).and_return(0...5)
    
    first_nested_failures = [mock('first nested failure'), mock('second nested failure')]
    second_nested_failures = [mock('third nested failure')]
    
    success.stub!(:nested_failures).and_return(first_nested_failures, second_nested_failures)
    
    failure = mock('parse failure')
    failure.stub!(:failure?).and_return(true)
    
    @embedded_expression.stub!(:parse_at).and_return(success, success, failure)
    
    result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should_be_success
    
    (first_nested_failures + second_nested_failures).each do |nested_failure|
      result.nested_failures.should_include(nested_failure)
    end
  end
end