require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A nonterminal symbol" do
  setup do
    @grammar = mock("Grammar")
    @nonterminal = NonterminalSymbol.new(:foo, @grammar)
  end
  
  it "retains a reference to the grammar of which it's a member" do
    @nonterminal.grammar.should equal(@grammar)
  end
  
  it "has a string representation" do
    @nonterminal.to_s.should == 'foo'
  end
  
  it "propagates parsing to the parsing expression to which it refers" do
    referrent_expression = mock("Associated parsing expression")
    @grammar.should_receive(:get_parsing_expression).with(@nonterminal).and_return(referrent_expression)
    parse_result_of_referrent = successful_parse_result
    referrent_expression.stub!(:parse_at).and_return(parse_result_of_referrent)

    result = @nonterminal.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
    result.should be_success
    result == parse_result_of_referrent
  end
end