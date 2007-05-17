require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An &-predication on a terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @and_predicate = AndPredicate.new(@terminal)
  end
  
  it "succeeds without updating the index upon parsing matching input" do
    input = @terminal.prefix
    index = 0
    result = @and_predicate.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_success
    
    result.should be_success
    
    result.interval.end.should == index
  end
  
  it "fails upon parsing non-matching input" do
    input = "baz"
    result = @and_predicate.parse_at(input, 0, parser_with_empty_cache_mock)
    result.should be_failure
  end
  
  it "has a string representation" do
    @and_predicate.to_s.should == '&("foo")'
  end
end

describe "A sequence with terminal symbol followed by an &-predicate on another terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @and_predicate = AndPredicate.new(TerminalSymbol.new("bar"))
    @sequence = Sequence.new([@terminal, @and_predicate])
  end
  
  it "succeeds when look-ahead predicate matches, without updating the index past the end of the first terminal" do
    input = "---" + @terminal.prefix + @and_predicate.expression.prefix
    index = 3
    result = @sequence.parse_at(input, index, parser_with_empty_cache_mock)
    result.should be_a_success
    result.interval.end.should == index + @terminal.prefix.size
  end
  
  it "fails when look-ahead predicate does not match" do
    input = "---" + @terminal.prefix + "baz"
    index = 3
    @sequence.parse_at(input, index, parser_with_empty_cache_mock).should be_a_failure
  end
end