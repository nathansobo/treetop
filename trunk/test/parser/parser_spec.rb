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
    root_nonterminal.should_receive(:parse_at).with(input, 0, @parser).and_return(parse_result)
    @grammar.should_receive(:root).and_return(root_nonterminal)
    
    parse_result.should_receive(:success?).and_return(true)
    parse_result.should_receive(:interval).twice.and_return(0...2)
    @parser.parse(input).should_be_failure
  end
  
  specify "creates a new node cache on call to parse" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    parse_result.should_receive(:success?).and_return(true)
    parse_result.should_receive(:interval).and_return(0...3)
    
    root_nonterminal.should_receive(:parse_at).with(input, 0, @parser).and_return(parse_result)
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input)
    @parser.node_cache.should_be_an_instance_of NodeCache
  end
end

