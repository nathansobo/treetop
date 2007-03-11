require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "Zero-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @zero_or_more = ZeroOrMore.new(@terminal)
  end
  
  specify "returns an empty kind of SequenceSyntaxNode when parsing epsilon without advancing the index" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    result.should_be_empty
    result.interval.end.should_equal index
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    (result.elements.collect {|e| e.text_value }).should_eql [@terminal.prefix]
    result.interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal(index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.size.should_equal 5
    result.interval.end.should_equal(index + (@terminal.prefix.size * 5))
  end
  
  specify "has a string representation" do
    @zero_or_more.to_s.should == '("foo")*'
  end
end

context "Zero-or-more of a terminal symbol with a method defined in its node class" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @zero_or_more = ZeroOrMore.new(@terminal)
    @zero_or_more.node_class_eval do
      def method
      end
    end
  end
  
  specify "returns a node that has that method upon a successful parse of epsilon" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, mock("Parser"))
    result.should_respond_to :method
  end
  
  specify "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_respond_to :method
  end
  
  specify "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, mock("Parser"))
    result.should_respond_to :method
  end
end

context "Zero-or-more of a parsing expression" do
  setup do
    @embedded_expression = mock('embedded parsing expression')
    @zero_or_more = ZeroOrMore.new(@embedded_expression)
  end
  
  specify "includes the sequence-terminating parse failure in the nested failures of the result" do
    success = mock('success')
    success.stub!(:failure?).and_return(false)
    success.stub!(:interval).and_return(0...3, 3...6)
    success.stub!(:nested_failures).and_return([])
    
    failure = mock('parse failure')
    failure.stub!(:failure?).and_return(true)
    
    @embedded_expression.stub!(:parse_at).and_return(success, success, failure)
    
    result = @zero_or_more.parse_at(mock('input'), 0, mock('parser'))
    result.nested_failures.should == [failure]
  end
  
  specify "includes any nested failures of successfully parsed sequence elements in the nested failures of the sequence" do
    success = mock('success')
    success.stub!(:failure?).and_return(false)
    success.stub!(:interval).and_return(0...3, 3...6)
    
    first_nested_failures = [mock('first nested failure'), mock('second nested failure')]
    second_nested_failures = [mock('third nested failure')]
    
    success.stub!(:nested_failures).and_return(first_nested_failures, second_nested_failures)
    
    failure = mock('parse failure')
    failure.stub!(:failure?).and_return(true)
    
    @embedded_expression.stub!(:parse_at).and_return(success, success, failure)
    
    result = @zero_or_more.parse_at(mock('input'), 0, mock('parser'))

    (first_nested_failures + second_nested_failures).each do |nested_failure|
      result.nested_failures.should_include nested_failure
    end
  end
  
end