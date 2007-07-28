require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe "A sequence of terminal symbols" do
  testing_expression '"foo" "bar" "baz"'
  
  it "parses matching input successfully" do
    parse('foobarbaz') do |result|
      result.should be_success
    end
  end
end

# 
# describe "A sequence parsing expression with multiple terminal symbols as elements" do
#   before do
#     @elts = ["foo", "bar", "baz"]
#     @sequence = Sequence.new(@elts.collect { |w| TerminalSymbol.new(w) })
#   end
#   
#   it "returns a successful result with correct elements when matching input is parsed" do
#     input = @elts.join
#     index = 0
#     result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
#     result.should be_success
#     result.elements.collect(&:text_value).should == @elts
#     result.interval.end.should == index + input.size
#   end
#   
#   it "returns a successful result with correct elements when matching input is parsed when starting at a non-zero index" do
#     input = "----" + @elts.join
#     index = 4
#     result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
#     result.should be_success
#     result.elements.collect(&:text_value).should == @elts
#     result.interval.end.should == index + @elts.join.size
#   end
#   
#   it "has a string representation" do
#     @sequence.to_s.should == '("foo" "bar" "baz")'
#   end
# end
# 
# describe "The result of a sequence parsing expression with one element and a method defined in its node class" do
#   before do
#     @elt = parsing_expression_mock("parsing expression in sequence")
#     @elt_result = parse_success
#     @elt.stub!(:parse_at).and_return(@elt_result)
# 
#     @sequence = Sequence.new([@elt]) do
#       def method
#       end
#     end
#     
#     @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
#   end
#   
#   it "has a value that is a kind of of SequenceSyntaxNode" do
#     @result.should be_a_kind_of(SequenceSyntaxNode)
#   end
#   
#   it "responds to the method defined in the node class" do
#     @result.should respond_to(:method)
#   end
# end
# 
# describe "The result of a sequence parsing expression with specificed custom node class and a node class eval block" do
# 
#   before do
#     @elt = parsing_expression_mock("parsing expression in sequence")
#     @elt_result = parse_success
#     @elt.stub!(:parse_at).and_return(@elt_result)
#     
#     @node_class = Class.new(SequenceSyntaxNode)
# 
#     @sequence = Sequence.new([@elt]).with_node_class(@node_class) {
#       def a_method
#       end
#     }
#     
#     @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
#   end
#   
#   it "is an instance of that class" do
#     @result.should be_an_instance_of(@node_class)
#   end
#   
#   it "responds to a method defined in the node class eval block " do
#     @result.should respond_to(:a_method)
#   end
# end
# 
# describe "The result of a sequence parsing expression with one element and a method defined in its node class via the evaluation of a string" do
#   before do
#     @elt = parsing_expression_mock("parsing expression in sequence")
#     @elt_result = parse_success
#     @elt.stub!(:parse_at).and_return(@elt_result)
# 
#     @sequence = Sequence.new([@elt])
#     @sequence.node_class_eval %{
#       def method
#       end
#     }
#     
#     @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
#   end
#   
#   it "has a value that is a kind of of SequenceSyntaxNode" do
#     @result.should be_a_kind_of(SequenceSyntaxNode)
#   end
#   
#   it "responds to the method defined in the node class" do
#     @result.should respond_to(:method)
#   end
# end
# 
# describe "The parse result of a sequence of two terminals when the second fails to parse" do
#   before do
#     @terminal_1 = TerminalSymbol.new('{')
#     @terminal_2 = TerminalSymbol.new('}')
#     @sequence = Sequence.new([@terminal_1, @terminal_2])
#     
#     @index = 0
#     
#     @result = @sequence.parse_at('{x', @index, parser_with_empty_cache_mock)
#   end
#   
#   it "is itself a failure" do
#     @result.should be_a_failure
#   end
#   
#   it "has an index equivalent to the start index of the parse" do
#     @result.index.should == @index
#   end
#   
#   it "has a single nested failure for the second terminal's failure" do
#     nested_failures = @result.nested_failures
#     nested_failures.size.should == 1
#     terminal_failure = nested_failures.first
#     terminal_failure.should be_an_instance_of(TerminalParseFailure)
#     terminal_failure.expression.should == @terminal_2
#   end
# end
# 
# describe "The result of a sequence whose child expressions return successfully with nested failures" do
#   before(:each) do
#     @elt_1 = parsing_expression_mock("first parsing expression in sequence")
#     @elt_1_result = parse_success_with_nested_failure_at(2)
#     @elt_1.stub!(:parse_at).and_return(@elt_1_result)
# 
#     @elt_2 = parsing_expression_mock("second parsing expression in sequence")
#     @elt_2_result = parse_success_with_nested_failure_at(4)
#     @elt_2.stub!(:parse_at).and_return(@elt_2_result)
# 
#     @sequence = Sequence.new([@elt_1, @elt_2])
#     
#     @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
#   end
#   
#   it "has the highest-indexed of its child results' nested failures as its nested failures" do
#     @result.nested_failures.should == [@elt_2_result.nested_failures.first]
#   end
# end
# 
# describe "The result of a sequence whose first child expression returns successfully with nested failures and whose second expression fails at the same index" do
#   before(:each) do    
#     @elt_1 = mock("first parsing expression in sequence")
#     @elt_1_result = parse_success_with_nested_failure_at(2)
#     @elt_1.stub!(:parse_at).and_return(@elt_1_result)
# 
#     @elt_2 = mock("second parsing expression in sequence")
#     @elt_2_result = terminal_parse_failure_at(2)
#     @elt_2.stub!(:parse_at).and_return(@elt_2_result)
# 
#     @sequence = Sequence.new([@elt_1, @elt_2])
#     
#     @result = @sequence.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
#   end
#   
#   it "has the nested failure of the successfully parsed expression as well as the failure of the second as its nested failures" do
#     nested_failures = @result.nested_failures
#         
#     nested_failures.size.should == 2
#     nested_failures.should include(@elt_1_result.nested_failures.first)
#     nested_failures.should include(@elt_2_result)
#   end
# end
# 
# describe "A sequence with uniquely-named nonterminal elements and a node class with a method with the same name as the last of the elements" do  
#   before do
#     grammar = Grammar.new
#     node_class = Class.new(SequenceSyntaxNode) do
#       def baz
#         'baz'
#       end
#     end
#     
#     @existing_method = node_class.instance_method(:baz)
#     @sequence = Sequence.new([grammar.nonterminal_symbol(:foo), grammar.nonterminal_symbol(:bar), grammar.nonterminal_symbol(:baz)]).with_node_class(node_class)
#   end
#   
#   it "defines accessor methods for the first two elements automatically" do
#     node_class = @sequence.node_class
#     elements = [mock('result of foo'), mock('result of bar')]
#     node = node_class.new(@sequence, "foobarbaz", 0...9, elements, [])
#     
#     node.foo.should == elements[0]
#     node.bar.should == elements[1]
#   end
#   
#   it "does not define a method automatically for the last element, leaving the existing method" do
#     @sequence.node_class.instance_method(:baz).should == @existing_method
#   end
# end