require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
  
context "One-or-more of a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @one_or_more = OneOrMore.new(@terminal)
  end
  
  specify "fails when parsing epsilon with the failure of the nested expression to parse once as a subtree of its failure tree" do
    index = 0
    epsilon = ""
    result = @one_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(FailedParseResult)
    result.interval.should == (index...index)
    
    failure_tree = result.failure_tree
    failure_tree.should_not be_nil
    
    subtrees = failure_tree.subtrees
    subtrees.size.should == 1
    subtrees.first.expression.should == @terminal
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol, with a failure subtree representing the failure terminating the sequence" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)

    result.should be_an_instance_of SuccessfulParseResult
    result.interval.end.should equal index + @terminal.prefix.size

    value = result.value
    value.should be_a_kind_of(SequenceSyntaxNode)
    (value.elements.collect {|e| e.text_value }).should eql [@terminal.prefix]

    failure_tree = result.failure_tree
    failure_tree.should_not be_nil
    subtrees = failure_tree.subtrees
    subtrees.size.should == 1
    subtrees.first.expression.should == @terminal
    subtrees.first.index.should == index + @terminal.prefix.length
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    
    value = result.value
    value.should be_a_kind_of SequenceSyntaxNode
    value.elements.size.should equal 5
    value.interval.end.should equal(index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    
    value = result.value
    value.should be_a_kind_of SequenceSyntaxNode
    value.elements.size.should == 5
    value.interval.end.should == (index + (@terminal.prefix.size * 5))
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
    result.should respond_to :method
  end
  
  specify "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @one_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should respond_to :method
  end
end

context "The result of parsing a one-or-more of an expression, when the repeated expression successfully parses once with failure trees and then fails" do
  setup do
    @expression = mock('expression that is repeated')
    
    @subresult_1 = successful_parse_result_with_failure_tree_for(@expression)
    @subresult_2 = failed_parse_result_for(@expression)
    
    @expression.stub!(:parse_at).and_return(@subresult_1, @subresult_2)
        
    @one_or_more = OneOrMore.new(@expression)
    
    @result = @one_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "is a success" do
    @result.should be_an_instance_of(SuccessfulParseResult)
  end
  
  specify "has a failure tree with the highest-indexed failures encountered during the parse as subtrees" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    subtrees = failure_tree.subtrees
        
    subtrees.size.should == 1
    subtrees.should include(@subresult_1.failure_tree)
  end
end
