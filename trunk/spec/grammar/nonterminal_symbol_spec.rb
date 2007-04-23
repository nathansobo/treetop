require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
  end
  
  specify "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should_equal(@grammar)
  end
  
  specify "has a string representation" do
    @nonterminal.to_s.should == 'foo'
  end
  
  specify "propagates parsing to the parsing expression to which it refers" do
    referrent_expression = mock("Associated parsing expression")
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(referrent_expression)
    parse_result_of_referrent = successful_parse_result_for(referrent_expression)
    referrent_expression.stub!(:parse_at).and_return(parse_result_of_referrent)

    result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of SuccessfulParseResult
    result.value.should == parse_result_of_referrent.value
  end
    
  specify "returns a failure tree in the successful result of the referrent expression as a subtree of the failure tree of its own result" do
    referrent_expression = mock("Associated parsing expression")
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(referrent_expression)
    parse_result_of_referrent = successful_parse_result_with_failure_tree_for(referrent_expression)
    referrent_expression.stub!(:parse_at).and_return(parse_result_of_referrent)

    result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of SuccessfulParseResult
    result.value.should == parse_result_of_referrent.value
    result.failure_tree.subtrees.should == [parse_result_of_referrent.failure_tree]
  end
  
  specify "if the referrent expression fails to parse, returns a failure tree with the failure of the referrent expression as a subtree of its failure tree" do
    referrent_expression = mock("Associated parsing expression")
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(referrent_expression)
    parse_result_of_referrent = failed_parse_result_for(referrent_expression)
    referrent_expression.stub!(:parse_at).and_return(parse_result_of_referrent)

    result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of FailedParseResult
    result.failure_tree.subtrees.should == [parse_result_of_referrent.failure_tree]
  end
end