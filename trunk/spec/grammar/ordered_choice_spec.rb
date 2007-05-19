require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An ordered choice parsing expression with three terminal alternatives" do
  setup do
    @alts = ["foo", "bar", "baz"]
    @choice = OrderedChoice.new(@alts.collect { |alt| TerminalSymbol.new(alt) })
  end
  
  it "returns a SuccessfulParseResult with the value of the first alternative as its value if it succeeds" do
    result = @choice.parse_at(@alts[0], 0, parser_with_empty_cache_mock)
    result.should be_success
    result.text_value.should == @alts[0]
  end

  it "has a string representation" do
    @choice.to_s.should == '("foo" / "bar" / "baz")'
  end
end

describe "The result of an ordered choice with three terminal alternatives, if the second is successful" do
  setup do
    @alts = ["foo", "bar", "baz"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at(@alts[1].prefix, 0, parser_with_empty_cache_mock)
  end
  
  it "is an instance SuccessfulParseResult" do
    @result.should be_success
  end
  
  it "is the parse result of the second terminal" do
    @result.should be_a_kind_of(TerminalSyntaxNode)
    @result.text_value.should == @alts[1].prefix
  end
  
  it "has the failure of the first terminal alternative as a nested failure" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 1
    nested_failures.first.expression.should == @alts[0]
  end
end

describe "The result of an ordered choice with three terminal alternatives, if the third is successful" do
  setup do
    @alts = ["foo", "bar", "baz"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at(@alts[2].prefix, 0, parser_with_empty_cache_mock)
  end
  
  it "is an instance SuccessfulParseResult" do
    @result.should be_success
  end
  
  it "is the parse result of the third terminal" do
    @result.should be_a_kind_of(TerminalSyntaxNode)
    @result.text_value.should == @alts[2].prefix
  end  
  
  it "has the failures of the first two alternatives as its nested failures" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 2
    nested_failures[0].expression.should == @alts[0]
    nested_failures[1].expression.should == @alts[1]
  end
end

describe "The result of an ordered choice with two terminal alternatives, if niether is successful" do
  setup do
    @alts = ["foo", "bar"].collect { |alt| TerminalSymbol.new(alt) }
    @choice = OrderedChoice.new(@alts)

    @result = @choice.parse_at('crapola', 0, parser_with_empty_cache_mock)
  end
  
  it "is an instance ParseFailure" do
    @result.should be_an_instance_of(ParseFailure)
  end
  
  it "has the the failures of its alternatives as nested failures" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 2
    
    nested_failures[0].expression.should == @alts[0]
    nested_failures[1].expression.should == @alts[1]    
  end
end

describe "The result of an ordered choice with two alternatives when the first fails with a nested failure at the same index as a nested failure on the successful result of the second alternative" do
  before(:each) do
    @alt_1 = mock('first alternative')
    @result_1 = parse_failure_at_with_nested_failure_at(0, 7)
    @alt_1.stub!(:parse_at).and_return(@result_1)
    
    @alt_2 = mock('second alternative')
    @result_2 = parse_success_with_nested_failure_at(7)
    @alt_2.stub!(:parse_at).and_return(@result_2)
    
    @choice = OrderedChoice.new([@alt_1, @alt_2])
    @result = @choice.parse_at(mock('input'), 0, parser_with_empty_cache_mock)
  end
  
  it "has both nested failures encountered" do
    nested_failures = @result.nested_failures
    nested_failures.size.should == 2
    
    nested_failures.should include(@result_1.nested_failures.first)
    nested_failures.should include(@result_2.nested_failures.first)
  end
end