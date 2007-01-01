require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A new parser" do
  setup do
    @grammar = mock("Grammar")
    @parser = Parser.new(@grammar)
  end
  
  specify "invokes parse_at on its grammar's root nonterminal when parse is called" do
    input = "foo"
    root_nonterminal = mock("Root nonterminal")
    parse_result = mock("Parse result")
    root_nonterminal.should_receive(:parse_at).with(input, 0, @parser).and_return(parse_result)
    @grammar.should_receive(:root).and_return(root_nonterminal)

    @parser.parse(input).should_equal parse_result
  end
  
  
end

