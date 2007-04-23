require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "The result of a sequence parsing expression with one element, when that element parses successfully" do
  setup do
    @element = mock("Parsing expression in sequence")
    @elt_result = successful_parse_result_for(@elt)
    @elt.stub!(:parse_at).and_return(@elt_result)
    @sequence = Sequence.new([@elt])
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)    
  end
      
  specify "returns a SuccessfulParseResult with a SequenceSyntaxNode value with the element's parse result as an element if the parse is successful" do    
    @result.should be_an_instance_of(SuccessfulParseResult)
    @result.value.should_be_a_kind_of SequenceSyntaxNode
    @result.value.elements.should_eql [@elt_result.value]
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

context "The result of a sequence parsing expression with one element and a method defined in its node class" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @elt_result = successful_parse_result_for(@elt)
    @elt.stub!(:parse_at).and_return(@elt_result)

    @sequence = Sequence.new([@elt])
    @sequence.node_class_eval do
      def method
      end
    end
    
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "has a value that is a kind of of SequenceSyntaxNode" do
    @result.value.should be_a_kind_of(SequenceSyntaxNode)
  end
  
  specify "responds to the method defined in the node class" do
    @result.should_respond_to :method    
  end
end

context "The result of a sequence parsing expression with one element and a method defined in its node class via the evaluation of a string" do
  setup do
    @elt = mock("Parsing expression in sequence")
    @elt_result = successful_parse_result_for(@elt)
    @elt.stub!(:parse_at).and_return(@elt_result)

    @sequence = Sequence.new([@elt])
    @sequence.node_class_eval %{
      def method
      end
    }
    
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "has a value that is a kind of of SequenceSyntaxNode" do
    @result.value.should be_a_kind_of(SequenceSyntaxNode)
  end
  
  specify "responds to the method defined in the node class" do
    @result.should_respond_to :method    
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
    @sequence = Sequence.new([@elt_1, @elt_2])
    
    @elt_1_result = successful_parse_result_with_failure_tree_for(@elt_1)
    @elt_1.stub!(:parse_at).and_return(@elt_1_result)
    @elt_2.stub!(:parse_at).and_return(failed_parse_result_for(@elt_2))

    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "is a failure" do
    @result.should be_failure
  end
  
  specify "has a failure tree with two subtrees representing the failures that occurred during the parse" do
    failure_tree = @result.failure_tree
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.subtrees.size.should == 2
    
    subtrees = failure_tree.subtrees    
    elt_1_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_1 }
    elt_2_subtree = subtrees.find {|failure_tree| failure_tree.expression == @elt_2 }
    
    elt_1_subtree.should_not be_nil
    elt_1_subtree.should == @elt_1_result.failure_tree
    elt_2_subtree.should be_an_instance_of(FailureLeaf)
  end
  
end

context "The parse result of a sequence whose first and second elements parse successfully with failure trees" do
  setup do
    @elt_1 = mock('first element')
    @elt_2 = mock('second element')
    
    @elt_1_result = successful_parse_result_with_failure_tree_for(@elt_1, 0...5)
    @elt_1.stub!(:parse_at).and_return(@elt_1_result)
    
    @elt_2_result = successful_parse_result_with_failure_tree_for(@elt_1, 5...10)
    @elt_2.stub!(:parse_at).and_return(@elt_2_result)
    
    @sequence = Sequence.new([@elt_1, @elt_2])    
    @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  specify "is a success" do
    @result.should be_success
  end
  
  specify "has a failure tree with the failure trees encountered during the parse as subtrees" do
    failure_tree = @result.failure_tree
    failure_tree.should_not be_nil
    failure_tree.should be_an_instance_of(FailureTree)
    failure_tree.subtrees.size.should == 2
    
    subtrees = failure_tree.subtrees
    failure_tree.subtrees.should include(@elt_1_result.failure_tree)
    failure_tree.subtrees.should include(@elt_2_result.failure_tree)
  end
end