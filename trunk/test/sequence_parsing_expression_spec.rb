require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A sequence parsing expression with one element" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @sequence = SequenceParsingExpression.new([@elt])
  end
  
  specify "is a kind of CompositeParsingExpression" do
    @sequence.should_be_a_kind_of SequenceParsingExpression
  end
  
  specify "attempts to parse its single element upon a call to parse_at" do
    input = "foo"
    index = 0
    parser = mock("Parser")
    mock_element(input, index, parser)
    @sequence.parse_at(input, index, parser)
  end
  
  specify "returns a SequenceSyntaxNode with the elements parse result as a child if it is parsed successfully" do
    input = "foo"
    index = 0
    parser = mock("Parser")
    
    mock_element(input, index, parser)
    result = @sequence.parse_at(input, index, parser)
    result.should_be_an_instance_of SequenceSyntaxNode
  end
  
  def mock_element(input, index, parser)
  
    elt_result = mock("First element's parse result")
    elt_interval = 0...5
    elt_result.should_receive(:interval).and_return(elt_interval)
  
    @elt.should_receive(:parse_at).with(input, index, parser).and_return(elt_result)
  end
  
end