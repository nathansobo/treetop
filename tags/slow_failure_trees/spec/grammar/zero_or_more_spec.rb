require 'rubygems'
require 'spec'

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
    result = @zero_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    
    result.should be_an_instance_of(SuccessfulParseResult)
    result.consumed_interval.end.should_equal index
    
    value = result.value
    value.should be_a_kind_of(SequenceSyntaxNode)
    value.should be_empty
  end
  
  specify "returns a sequence with one element when parsing input matching one of that terminal symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)

    value = result.value    
    value.should_be_a_kind_of SequenceSyntaxNode
    value.elements.size.should == 1
    value.elements.first.text_value.should == @terminal.prefix
    
    result.consumed_interval.end.should_equal index + @terminal.prefix.size
  end
  
  specify "returns a sequence of size 5 when parsing input with 5 consecutive matches of that terminal symbol" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    
    result.should be_an_instance_of(SuccessfulParseResult)
    value = result.value
    value.should be_a_kind_of(SequenceSyntaxNode)
    value.elements.size.should_equal 5
    
    result.consumed_interval.end.should_equal(index + (@terminal.prefix.size * 5))
  end
  
  specify "correctly matches multiples not starting at index 0" do
    index = 30
    input = ("x" * 30) + (@terminal.prefix * 5)
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    
    value = result.value
    value.should be_a_kind_of(SequenceSyntaxNode)
    value.elements.size.should_equal 5
    
    result.consumed_interval.end.should_equal(index + (@terminal.prefix.size * 5))
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
      def a_method
        'foo'
      end
    end
  end
  
  specify "returns a node that has that method upon a successful parse of epsilon" do
    index = 0
    epsilon = ""
    result = @zero_or_more.parse_at(epsilon, index, parser_with_empty_cache_mock)
    
    result.should be_an_instance_of(SuccessfulParseResult)
    result.value.should respond_to(:a_method)
  end
  
  specify "returns a node that has that method upon a successful parse of one of the repeated symbol" do
    index = 0
    input = @terminal.prefix + "barbaz"
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.value.should_respond_to :a_method
  end
  
  specify "returns a node that has that method upon a successful parse of multiple of the repeated symbols" do
    index = 0
    input = @terminal.prefix * 5
    result = @zero_or_more.parse_at(input, index, parser_with_empty_cache_mock)
    result.value.should respond_to(:a_method)
  end
end

context "The result of parsing zero or more of an expression, when some results of the expression have failure trees" do
  setup do
    @expression = mock('repeated parsing expression')
    @zero_or_more = ZeroOrMore.new(@expression)
    
    @parse_result_1 = successful_parse_result_with_failure_tree_for(@expression)
    @parse_result_2 = successful_parse_result_with_failure_tree_for(@expression, 5...10)
    @parse_result_3 = failed_parse_result_for(@expression, 10)
    
    @expression.stub!(:parse_at).and_return(@parse_result_1, @parse_result_2, @parse_result_3)
    
    @result = @zero_or_more.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "has a failure tree with the maximal failure that occured during the parse as its subtree" do    
    subtrees = @result.failure_tree.subtrees
    subtrees.size.should == 1
    subtrees.should include(@parse_result_2.failure_tree)
  end
end

