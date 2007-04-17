require 'rubygems'
require 'spec'

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
  
  specify "returns a SuccessfulParseResult with a SequenceSyntaxNode value with the element's parse result as an element if the parse is successful" do
    setup_sequence_element_to_successfully_parse
    result = @sequence.parse_at(@input, @index, @parser)
    result.should be_an_instance_of(SuccessfulParseResult)
    result.value.should_be_a_kind_of SequenceSyntaxNode
    result.value.elements.should_eql [@elt_result_value]
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
    (result.value.elements.collect {|elt| elt.text_value}).should_eql @elts
    result.consumed_interval.end.should_equal index + input.size
  end
  
  specify "returns a successful result with correct elements when matching input is parsed when starting at a non-zero index" do
    input = "----" + @elts.join
    index = 4
    result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
    result.should_be_success
    (result.value.elements.collect {|elt| elt.text_value}).should_eql @elts
    result.consumed_interval.end.should_equal index + @elts.join.size
  end
  
  specify "has a string representation" do
    @sequence.to_s.should == '("foo" "bar" "baz")'
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

context "The parse result of a sequence of two terminals when the second fails to parse" do
  setup do
    @terminal_1 = TerminalSymbol.new('{')
    @terminal_2 = TerminalSymbol.new('}')
    @sequence = Sequence.new([@terminal_1, @terminal_2])
    
    @index = 0
    
    @result = @sequence.parse_at('{x', @index, parser_with_empty_cache_mock)
  end
  
  specify "is itself a failure" do
    @result.should be_a_failure
  end
  
  specify "has an index equivalent to the start index of the parse" do
    @result.index.should == @index
  end
  
  specify "has a failure tree with one failure leaf representing the failure of the second terminal" do
    failure_tree = @result.failure_tree
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.index.should == 0
    failure_subtrees = failure_tree.subtrees
    failure_subtrees.size.should == 1
    
    failure_leaf = failure_subtrees.first
    failure_leaf.should be_an_instance_of(FailureLeaf)
    failure_leaf.expression.should == @terminal_2
    failure_leaf.index.should == @index + 1
  end
end

context "The parse result of a sequence whose first element's result is successful with a failure tree and whose second fails" do
  setup do
    @elt_1 = mock('first element')
    @elt_2 = mock('second element')
    
    @elt_1_value = mock('value of first element')
    @elt_1_value_interval = 1...5
    @elt_1_value.stub!(:interval).and_return(@elt_1_value_interval)
    @elt_1_failure_subtree_index = 8
    @elt_1_failure_subtree = FailureLeaf.new(mock('failing terminal expression'), @elt_1_failure_subtree_index)
    @elt_1_result = SuccessfulParseResult.new(@elt_1, @elt_1_value, [@elt_1_failure_subtree])
    @elt_1.stub!(:parse_at).and_return(@elt_1_result)
    
    @elt_2_failure_index = 5
    @elt_2_result = FailedParseResult.new(@elt_2, @elt_2_failure_index, [])
    @elt_2.stub!(:parse_at).and_return(@elt_2_result)
    
    @sequence = Sequence.new([@elt_1, @elt_2])
    
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "is a failure" do
    @result.should be_failure
  end
  
  specify "has a failure tree with two subtrees, one with an additional subtree referring to the first element and one referring to the second element" do
    failure_tree = @result.failure_tree
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.subtrees.size.should == 2
    
    subtrees = failure_tree.subtrees    
    elt_1_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_1 }
    elt_2_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_2 }
    
    elt_1_subtree.should_not be_nil
    elt_1_subtree.subtrees.should include(@elt_1_failure_subtree)  
    elt_2_subtree.should be_an_instance_of(FailureLeaf)
  end
end

context "The parse result of a sequence whose first and second elements parse successfully failure trees" do
  setup do
    @elt_1 = mock('first element')
    @elt_2 = mock('second element')
    
    @elt_1_value = mock('value of first element')
    @elt_1_value_interval = 1...5
    @elt_1_value.stub!(:interval).and_return(@elt_1_value_interval)
    @elt_1_failure_subtree_index = 8
    @elt_1_failure_subtree = FailureLeaf.new(mock('failing terminal expression'), @elt_1_failure_subtree_index)
    @elt_1_result = SuccessfulParseResult.new(@elt_1, @elt_1_value, [@elt_1_failure_subtree])
    @elt_1.stub!(:parse_at).and_return(@elt_1_result)
    
    @elt_2_value = mock('value of first element')
    @elt_2_value_interval = 5...10
    @elt_2_value.stub!(:interval).and_return(@elt_2_value_interval)
    @elt_2_failure_subtree_index = 20
    @elt_2_failure_subtree = FailureLeaf.new(mock('failing terminal expression'), @elt_2_failure_subtree_index)
    @elt_2_result = SuccessfulParseResult.new(@elt_2, @elt_2_value, [@elt_2_failure_subtree])
    @elt_2.stub!(:parse_at).and_return(@elt_2_result)
    
    @sequence = Sequence.new([@elt_1, @elt_2])    
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "is a success" do
    @result.should be_success
  end
  
  specify "has a failure tree with two subtrees, both with an additional failure leaf attached as a subtree" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.subtrees.size.should == 2
    
    subtrees = failure_tree.subtrees    
    elt_1_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_1 }
    elt_2_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_2 }
    
    elt_1_subtree.should_not be_nil
    elt_1_subtree.subtrees.should include(@elt_1_failure_subtree)  

    elt_2_subtree.should_not be_nil
    elt_2_subtree.subtrees.should include(@elt_2_failure_subtree)  
  end
end

def setup_sequence_element_to_successfully_parse  
  @input = "foo"
  @index = 0
  @parser = parser_with_empty_cache_mock
  
  @elt_result = mock("First element's parse result")
  @elt_interval = 0...5
  @elt_result.stub!(:failure?).and_return(false)
  @elt_result.stub!(:failure_tree).and_return(nil)  
  @elt_result.stub!(:consumed_interval).and_return(@elt_interval)
  
  @elt_result_value = mock("Value of first element's parse result")
  @elt_result.stub!(:value).and_return(@elt_result_value)

  @elt.should_receive(:parse_at).with(@input, @index, @parser).and_return(@elt_result)
end