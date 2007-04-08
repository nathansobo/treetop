require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A sequence parsing expression with one element" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @sequence = Sequence.new([@elt])
  end
    
  specify "attempts to parse its single element upon a call to parse_at" do
    setup_sequence_element_to_successfully_parse
    @sequence.parse_at(@input, @index, @parser)
  end
  
  specify "returns a SequenceSyntaxNode with the element's parse result as an element if the parse is successful" do
    setup_sequence_element_to_successfully_parse
    result = @sequence.parse_at(@input, @index, @parser)
    result.should_be_a_kind_of SequenceSyntaxNode
    result.elements.should_eql [@elt_result]
  end
  
  specify "returns a parse failure if the parse of an element fails with that element's failure as a nested failure" do
    input = "foo"
    index = 0
    parser = parser_with_empty_cache_mock
  
    first_failure = NonterminalParseFailure.new(index, @elt, [])
    @elt.should_receive(:parse_at).with(input, index, parser).and_return(first_failure)
    
    result = @sequence.parse_at(input, index, parser)
    
    
    result.should_be_failure
    
    result.nested_failures.should_include first_failure
  end
  
  specify "returns a SequenceSyntaxNode with the any nested failures encountered during parsing if the element parses successfully" do
    setup_sequence_element_to_successfully_parse
    expected_nested_failures = [mock("first nested failure"), mock("second nested failure")]
    @elt_result.should_receive(:nested_failures).and_return expected_nested_failures
    
    result = @sequence.parse_at(@input, @index, @parser)
    result.nested_failures.should == expected_nested_failures
  end
end

context "A sequence parsing expression with multiple terminal symbols as elements" do
  setup do
    @elts = ["foo", "bar", "baz"]
    @sequence = Sequence.new(@elts.collect { |w| TerminalSymbol.new(w) })
  end
  
  specify "returns a successful result with correct elements when matching input is parsed" do
    input = @elts.join
    index = 0
    result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_success
    (result.elements.collect {|elt| elt.text_value}).should_eql @elts
    result.interval.end.should_equal index + input.size
  end
  
  specify "returns a successful result with correct elements when matching input is parsed when starting at a non-zero index" do
    input = "----" + @elts.join
    index = 4
    result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_success
    (result.elements.collect {|elt| elt.text_value}).should_eql @elts
    result.interval.end.should_equal index + @elts.join.size
  end
  
  specify "has a string representation" do
    @sequence.to_s.should == '("foo" "bar" "baz")'
  end
end

context "A sequence parsing expression with multiple elements with nested errors and a final element that fails to parse" do
  setup do
    @input = "foo"
    @parser = parser_with_empty_cache_mock
    elts = [mock("first element"), mock("second element"), mock("third element")]
    @sequence = Sequence.new(elts)
    
    @nested_failures_1 = [mock('failure 1')]
    @nested_failures_2 = [mock('failure 2'), mock('failure 3')]    
    @nested_failures_3 = [mock('failure 4')]
    
    first_result = mock("first element's result")
    first_result.stub!(:failure?).and_return(false)
    first_result.stub!(:interval).and_return(0...5)
    first_result.stub!(:nested_failures).and_return(@nested_failures_1)
    elts[0].stub!(:parse_at).and_return(first_result)

    second_result = mock("second element's result")
    second_result.stub!(:failure?).and_return(false)    
    second_result.stub!(:interval).and_return(5...10)
    second_result.stub!(:nested_failures).and_return(@nested_failures_2)
    elts[1].stub!(:parse_at).and_return(second_result)
    
    failure = NonterminalParseFailure.new(10, elts[2], @nested_failures_3)
    elts[2].stub!(:parse_at).and_return(failure)
  end
  
  specify "returns a failure that has all the nested failures encountered in the sequence" do
    result = @sequence.parse_at(@input, 0, @parser)
    result.should_be_an_instance_of NonterminalParseFailure
    
    (@nested_failures_1 + @nested_failures_2 + @nested_failures_3).each do |nested_failure|
      result.nested_failures.should_include nested_failure
    end
  end
  
end

context "A sequence parsing expression with one element and a method defined in its node class" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @sequence = Sequence.new([@elt])
    @sequence.node_class_eval do
      def method
      end
    end
  end
  
  specify "returns a SequenceSyntaxNode with the element's parse result as an element if the parse is successful" do
    setup_sequence_element_to_successfully_parse
    result = @sequence.parse_at(@input, @index, @parser)
    result.should_respond_to :method
  end  
end

context "A sequence parsing expression with one element and a method defined in its node class via a string evaluation" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @sequence = Sequence.new([@elt])
    @sequence.node_class_eval("def a_method\n\nend")
  end
  
  specify "returns a SequenceSyntaxNode with the element's parse result as an element if the parse is successful" do
    setup_sequence_element_to_successfully_parse
    result = @sequence.parse_at(@input, @index, @parser)
    result.should_respond_to :method
  end  
end


def setup_sequence_element_to_successfully_parse  
  @input = "foo"
  @index = 0
  @parser = parser_with_empty_cache_mock
  
  @elt_result = mock("First element's parse result")
  @elt_interval = 0...5
  @elt_result.stub!(:failure?).and_return(false)
  @elt_result.stub!(:interval).and_return(@elt_interval)
  @elt_result.stub!(:nested_failures).and_return([])

  @elt.should_receive(:parse_at).with(@input, @index, @parser).and_return(@elt_result)
end

