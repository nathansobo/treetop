require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new parser with a nonterminal that successfully consumes 0...5, returning a parse result with a failure tree" do
  setup do    
    @grammar = Grammar.new
    @root_expression = mock('parsing expression')
    @grammar.add_parsing_rule(@grammar.nonterminal_symbol(:foo), @root_expression)
    @parser = Parser.new(@grammar)
    
    @result_of_root_expression = successful_parse_result_with_failure_tree_for(@root_expression)
    @root_expression.stub!(:parse_at).and_return(@result_of_root_expression)
  end
  
  specify "returns the value associated with the root node if the parse is successful" do
    @parser.parse('12345').should_equal @result_of_root_expression.value
  end
  
  specify "returns a FailedParseResult if not all of the input is consumed, with a failure tree containing the failure tree of the root expression as a grandchild" do
    result = @parser.parse('123')
    result.should be_an_instance_of(FailedParseResult)
    
    failure_tree = result.failure_tree
    failure_tree.should_not be_nil
    subtrees = failure_tree.subtrees
    subtrees.first.subtrees.first.should == @result_of_root_expression.failure_tree
  end
  
  specify "creates a new parse cache on call to parse" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    
    root_nonterminal.stub!(:parse_at).and_return(successful_parse_result_for(root_nonterminal))
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input)
    @parser.parse_cache.should be_an_instance_of(ParseCache)
  end
  
  specify "can return a node cache for a specific parsing expression" do
    sequence_expression = mock("sequence expression")
    cache_for_sequence = mock("cache for sequence")
    @parser.parse_cache.should_receive(:[]).with(sequence_expression).and_return(cache_for_sequence)
    @parser.node_cache_for(sequence_expression).should == cache_for_sequence
  end
end

