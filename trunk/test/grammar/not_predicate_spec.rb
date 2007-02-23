require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "A !-predicate for a TerminalSymbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @not_predicate = NotPredicate.new(@terminal)
  end
  
  specify "fails upon parsing matching input" do
    input = @terminal.prefix
    index = 0
    @not_predicate.parse_at(input, index, mock("Parser")).should_be_failure
  end
  
  specify "succeeds upon parsing non-matching input, without updating the index" do
    input = "baz"
    index = 0
    result = @not_predicate.parse_at(input, index, mock("Parser"))
    result.should_be_success
    result.interval.end.should_equal index
  end
  
  specify "has a string representation" do
    @not_predicate.to_s.should == '!("foo")'
  end
end

context "A sequence with terminal symbol followed by a !-predicate on another terminal symbol" do
  setup do
    @terminal = TerminalSymbol.new("foo")
    @not_predicate = NotPredicate.new(TerminalSymbol.new("bar"))
    @sequence = Sequence.new([@terminal, @not_predicate])
  end
  
  specify "fails when look-ahead predicate matches" do
    input = "---" + @terminal.prefix + @not_predicate.expression.prefix
    index = 3
    @sequence.parse_at(input, index, mock("Parser")).should_be_failure
  end
  
  specify "succeeds when look-ahead does not match, without advancing index beyond end of first terminal" do
    input = "---" + @terminal.prefix + "baz"
    index = 3
    result = @sequence.parse_at(input, index, mock("Parser"))
    result.should_be_success
    result.interval.end.should_equal index + @terminal.prefix.size
  end
end