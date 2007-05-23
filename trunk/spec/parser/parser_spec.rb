dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A new parser with a nonterminal that successfully consumes 0...5, returning a parse result with a failure tree" do
  before do    
    @grammar = Grammar.new
    @root_expression = mock('parsing expression')
    @grammar.add_parsing_rule(@grammar.nonterminal_symbol(:foo), @root_expression)
    @parser = Parser.new(@grammar)
    
    @result_of_root_expression = parse_success
    @root_expression.stub!(:parse_at).and_return(@result_of_root_expression)
  end
  
  it "returns the value associated with the root node if the parse is successful" do
    @parser.parse('12345').should == @result_of_root_expression
  end
  
  it "returns a ParseFailure if not all of the input is consumed" do
    result = @parser.parse('123')
    result.should be_an_instance_of(ParseFailure)
  end
  
  it "creates a new parse cache on call to parse" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    
    root_nonterminal.stub!(:parse_at).and_return(parse_success)
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input)
    @parser.parse_cache.should be_an_instance_of(ParseCache)
  end
  
  it "can return a node cache for a specific parsing expression" do
    parsing_expression = mock("parsing expression")
    cache_for_parsing_expression = mock("cache for parsing expression")
    @parser.parse_cache.should_receive(:[]).with(parsing_expression).and_return(cache_for_parsing_expression)
    @parser.node_cache_for(parsing_expression).should == cache_for_parsing_expression
  end
end

describe "A parser for a grammar with one rule that fails to parse with nested failures" do
  
  before(:each) do
    @grammar = Grammar.new
    @root_expression = mock('parsing expression')
    @grammar.add_parsing_rule(@grammar.nonterminal_symbol(:foo), @root_expression)
    @parser = Parser.new(@grammar)
    
    @result_of_root_expression = parse_failure_at_with_nested_failure_at(0, 5)
    @root_expression.stub!(:parse_at).and_return(@result_of_root_expression)
  end
  
  it "propagates the nested failures on the rule's result" do
    nested_failures = @parser.parse(mock('input')).nested_failures
    nested_failures.size.should == 1
    nested_failures.first.should == @result_of_root_expression.nested_failures.first
  end
end