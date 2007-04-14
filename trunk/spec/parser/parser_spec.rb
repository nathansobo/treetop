require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A new parser" do
  setup do
    @grammar = mock("Grammar")
    @parser = Parser.new(@grammar)
  end
  
  specify "invokes parse_at on its grammar's root nonterminal when parse is called" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    parse_result.should_receive(:success?).and_return(true)
    parse_result.should_receive(:interval).and_return(0...3)
    
    root_nonterminal.should_receive(:parse_at).with(input, 0, @parser).and_return(parse_result)
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input).should_equal parse_result
  end
  
  specify "fails to parse if all input is not consumed" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    nested_failures = [mock('a nested failure')]

    root_nonterminal.stub!(:parse_at).and_return(parse_result)
    @grammar.stub!(:root).and_return(root_nonterminal)
    
    parse_result.should_receive(:success?).and_return(true)
    parse_result.should_receive(:interval).twice.and_return(0...2)
    result = @parser.parse("input longer than parse result's interval")
    result.should_be_failure
  end
  
  specify "creates a new parse cache on call to parse" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    parse_result.should_receive(:success?).and_return(true)
    parse_result.should_receive(:interval).and_return(0...3)
    
    root_nonterminal.should_receive(:parse_at).with(input, 0, @parser).and_return(parse_result)
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input)
    @parser.parse_cache.should_be_an_instance_of ParseCache
  end
  
  specify "can return a node cache for a specific parsing expression" do
    sequence_expression = mock("sequence expression")
    cache_for_sequence = mock("cache for sequence")
    @parser.parse_cache.should_receive(:[]).with(sequence_expression).and_return(cache_for_sequence)
    @parser.node_cache_for(sequence_expression).should == cache_for_sequence
  end
end

