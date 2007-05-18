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
end