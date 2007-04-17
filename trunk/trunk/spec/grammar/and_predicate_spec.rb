require 'rubygems'
require 'spec/runner'

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
    result.interval.end.should == index
  end
  
  specify "fails upon parsing non-matching input" do
    input = "baz"
    @and_predicate.parse_at(input, 0, parser_with_empty_cache_mock).should be_a_failure
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
    result.interval.end.should == index + @terminal.prefix.size
  end
  
  specify "fails when look-ahead predicate does not match" do
    input = "---" + @terminal.prefix + "baz"
    index = 3
    @sequence.parse_at(input, index, parser_with_empty_cache_mock).should be_a_failure
  end
end


context "An &-predicate" do
  setup do
    @embedded_expression = mock('embedded parsing expression')
    @and_predicate = AndPredicate.new(@embedded_expression)
  end

  specify "propagates the failure of its embedded parsing expression as a nested failure on a failure result" do
    failure = NonterminalParseFailure.new(0, @embedded_expression, [])
    @embedded_expression.stub!(:parse_at).and_return(failure)
    
    result = @and_predicate.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_a_failure
    result.nested_failures.should == [failure]
  end
  
  specify "propagates the nested failures on the successful result of the embedded expression to its own result" do
    success = mock('success')
    success.stub!(:success?).and_return(true)
    nested_failures = [mock('first nested failure'), mock('second nested failure')]
    success.stub!(:nested_failures).and_return(nested_failures)
    @embedded_expression.stub!(:parse_at).and_return(success)
    
    result = @and_predicate.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.nested_failures.should == nested_failures
  end
end

