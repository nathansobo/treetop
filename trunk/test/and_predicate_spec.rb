require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "An and predicate for a TerminalSymbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @and_predicate = AndPredicate.new(@terminal)
  end
  
  specify "returns a SyntaxNode without updating the index on a parse of matching input" do
    input = @terminal.prefix
    index = 0
    result = @and_predicate.parse_at(input, index, mock("Parser"))
    result.should_be_an_instance_of SyntaxNode
    result.interval.end.should_equal index
  end
  
  specify "returns a ParseFailure on attempt to parse non-matching input" do
    input = "baz"
    @and_predicate.parse_at(input, 0, mock("Parser")).should_be_an_instance_of ParseFailure
  end
end