require 'rubygems'
require 'spec'
dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A non-empty terminal node" do
  setup do
    @terminal = Terminal.new("foo")
    @parser_instance = mock("Parser instance")
  end
    
  specify "reports that it is terminal" do
    @terminal.should_be_terminal
  end
  
  specify "reports that it is not nonterminal" do
    @terminal.should_not_be_nonterminal
  end
  
  specify "updates next index appropriately for input at zero index" do
    parse_result = @terminal.parse_at(0, "foobar", @parser_instance)
    parse_result.should_be_an_instance_of ParseResult
    parse_result.value.should_eql "foo"
    parse_result.end_index.should_equal 3
  end
  
  specify "updates next index appropriately for input at nonzero index" do
    parse_result = @terminal.parse_at(3, "barfoo", @parser_instance)
    parse_result.should_be_an_instance_of ParseResult
    parse_result.value.should_eql "foo"
    parse_result.end_index.should_equal 6
  end
  
  specify "returns a failure for a non matching prefix at parsing index" do
    @terminal.parse_at(0, "barfoo", @parser_instance).should_be_failure
  end
end

context "An empty terminal node" do
  setup do
    @terminal = Terminal.new("")
    @parser_instance = mock("Parser instance")
  end
  
  specify "does not advance index when parsing" do
    @terminal.parse_at(0, "barfoo", @parser_instance).end_index.should_equal 0
  end
end