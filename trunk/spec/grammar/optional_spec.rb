require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An optional terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @optional = Optional.new(@terminal)
  end
  
  specify "returns a SuccessfulParseResult with empty terminal node as its value on parsing epsilon" do
    epsilon = ""
    result = @optional.parse_at(epsilon, 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    result.value.should be_a_kind_of(TerminalSyntaxNode)
    result.value.should be_epsilon
  end
  
  specify "returns a SuccessfulParseResult with a terminal node matching the terminal symbol on parsing matching input" do
    result = @optional.parse_at(@terminal.prefix, 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of(SuccessfulParseResult)
    result.value.should be_a_kind_of(TerminalSyntaxNode)
    result.value.text_value.should eql @terminal.prefix
  end
  
  specify "has a string representation" do
    @optional.to_s.should == '("foo")?'
  end
end

context "The result of an optional parsing expression, when the optional expression fails to parse" do
  setup do
    @expression = mock('parsing expression that is made optional')
    @optional = Optional.new(@expression)
    
    @subexpression_result = failed_parse_result_for(@expression)
    @expression.stub!(:parse_at).and_return(@subexpression_result)
    
    @result = @optional.parse_at('', 0, parser_with_empty_cache_mock)
  end
  
  specify "is a SuccessfulParseResult" do
    @result.should be_an_instance_of(SuccessfulParseResult)
  end
  
  specify "has the failure of the optional expression to parse as a subtree of its failure tree" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    subtrees = failure_tree.subtrees
    subtrees.size.should == 1
    subtrees.first.should == @subexpression_result.failure_tree
  end
  
end