require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An ordered choice parsing expression with three terminal alternatives" do
  setup do
    @alts = ["foo", "bar", "baz"]
    @choice = OrderedChoice.new(@alts.collect { |alt| TerminalSymbol.new(alt) })
  end
  
  specify "returns the results of the first alternative if it succeeds" do
    @choice.parse_at(@alts[0], 0, mock("Parser")).text_value.should_eql @alts[0]
  end

  specify "returns the results of the second alternative if it succeeds" do
    @choice.parse_at(@alts[1], 0, mock("Parser")).text_value.should_eql @alts[1]
  end
  
  specify "returns the results of the third alternative if it succeeds" do
    @choice.parse_at(@alts[2], 0, mock("Parser")).text_value.should_eql @alts[2]
  end
  
  specify "fails if no alternative succeeds" do
    nonmatching_input = "bonk"
    @choice.parse_at(nonmatching_input, 0, mock("Parser")).should_be_failure
  end
  
  specify "has a string representation" do
    @choice.to_s.should == '("foo" / "bar" / "baz")'
  end
end

context "An ordered choice with two nonterminal alternatives" do
  setup do
    @alt1 = mock("first alternative")
    @alt2 = mock("second alternative")
    
    @choice = OrderedChoice.new([@alt1, @alt2])
  end
  
  specify "adds the failure of the first alternative as a nested failure in the successful result of the second alternative" do
    input = mock('input')
    index = 0
    parser = mock('parser')
    
    first_failure = NonterminalParseFailure.new(index, @alt1, [])
    @alt1.should_receive(:parse_at).with(input, index, parser).and_return(first_failure)
    
    second_success = SequenceSyntaxNode.new(input, index..5, [mock('element')], [])
    @alt2.should_receive(:parse_at).with(input, index, parser).and_return(second_success)
    
    result = @choice.parse_at(input, index, parser)
    result.nested_failures.should_include first_failure
  end
    
  specify "returns a failure with the failures of all the alternatives as nested failures if no alternative succeeds" do
    input = mock('input')
    index = 0
    parser = mock('parser')
    
    first_failure = NonterminalParseFailure.new(index, @alt1, [])
    @alt1.should_receive(:parse_at).with(input, index, parser).and_return(first_failure)
   
    second_failure = NonterminalParseFailure.new(index, @alt2, [])    
    @alt2.should_receive(:parse_at).with(input, index, parser).and_return(second_failure)
    
    result = @choice.parse_at(input, index, parser)
    result.nested_failures.should_include first_failure
    result.nested_failures.should_include second_failure
  end
end