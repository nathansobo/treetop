require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A sequence parsing expression with one element" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @sequence = Sequence.new([@elt])
  end
  
  specify "is a kind of CompositeParsingExpression" do
    @sequence.should_be_a_kind_of CompositeParsingExpression
  end
  
  specify "attempts to parse its single element upon a call to parse_at" do
    element_will_parse_input_successfully
    @sequence.parse_at(@input, @index, @parser)
  end
  
  specify "returns a SequenceSyntaxNode with the element's parse result as an element if the parse is successful" do
    element_will_parse_input_successfully
    result = @sequence.parse_at(@input, @index, @parser)
    result.should_be_an_instance_of SequenceSyntaxNode
    result.elements.should_eql [@elt_result]
  end
  
  specify "returns a parse failure if the parse of an element fails" do
    input = "foo"
    index = 0
    parser = mock("Parser")
  
    @elt.should_receive(:parse_at).with(input, index, parser).and_return(ParseFailure.new(index))
    
    result = @sequence.parse_at(input, index, parser)
  end
  
  def element_will_parse_input_successfully
    @input = "foo"
    @index = 0
    @parser = mock("Parser")
    
    @elt_result = mock("First element's parse result")
    @elt_interval = 0...5
    @elt_result.should_receive(:interval).and_return(@elt_interval)
  
    @elt.should_receive(:parse_at).with(@input, @index, @parser).and_return(@elt_result)
  end
end

context "A sequence parsing expression with multiple terminal symbols as elements" do
  setup do
    @elts = ["foo", "bar", "baz"]
    @input = @elts.join
    @sequence = Sequence.new(@elts.collect { |w| TerminalSymbol.new(w) })
  end
  
  specify "returns a SequenceSyntaxNode with correct elements when matching input is parsed" do
    result = @sequence.parse_at(@input, 0, mock("Parser"))
    result.should_be_an_instance_of SequenceSyntaxNode
    (result.elements.collect {|elt| elt.text_value}).should_eql @elts
  end
end