require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An &-predication on a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @and_predicate = AndPredicate.new(@terminal)
  end
  
  specify "succeeds without updating the index upon parsing matching input" do
    input = @terminal.prefix
    index = 0
    result = @and_predicate.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success
    
    result.should be_an_instance_of(SuccessfulParseResult)
    
    result.consumed_interval.end.should == index
  end
  
  specify "fails upon parsing non-matching input, with a FailureTree that has the failure of the predicated expression as a subtree" do
    input = "baz"
    result = @and_predicate.parse_at(input, 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of(FailedParseResult)
    
    failure_tree = result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.subtrees.size.should == 1
  end
  
  specify "has a string representation" do
    @and_predicate.to_s.should == '&("foo")'
  end
end

context "A sequence with terminal symbol followed by an &-predicate on another terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @and_predicate = AndPredicate.new(TerminalSymbol.new("bar"))
    @sequence = Sequence.new([@terminal, @and_predicate])
  end
  
  specify "succeeds when look-ahead predicate matches, without updating the index past the end of the first terminal" do
    input = "---" + @terminal.prefix + @and_predicate.expression.prefix
    index = 3
    result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_a_success
    result.consumed_interval.end.should == index + @terminal.prefix.size
  end
  
  specify "fails when look-ahead predicate does not match" do
    input = "---" + @terminal.prefix + "baz"
    index = 3
    @sequence.parse_at(input, index, parser_with_empty_cache_mock).should be_a_failure
  end
end

context "The result of an and predicate when the predicated expression parses successfully with a failure tree" do
  setup do
    @predicated_expression = mock('predicated expression')
    @and_predicate = AndPredicate.new(@predicated_expression)

    @predicated_expression_result = successful_parse_result_with_failure_tree_for(@predicated_expression)    
    @predicated_expression.stub!(:parse_at).and_return(@predicated_expression_result)
    
    @result = @and_predicate.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "should have a failure tree with the failure tree of the successful subexpression parse as its subtree" do    
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    
    failure_tree.subtrees.should include(@predicated_expression_result.failure_tree)
  end
end