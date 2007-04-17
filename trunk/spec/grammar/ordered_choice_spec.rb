require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An ordered choice parsing expression with three terminal alternatives" do
  setup do
    @alts = ["foo", "bar", "baz"]
    @choice = OrderedChoice.new(@alts.collect { |alt| TerminalSymbol.new(alt) })
  end
  
  specify "returns the results of the first alternative if it succeeds" do
    @choice.parse_at(@alts[0], 0, parser_with_empty_cache_mock).text_value.should_eql @alts[0]
  end

  specify "returns the results of the second alternative if it succeeds" do
    @choice.parse_at(@alts[1], 0, parser_with_empty_cache_mock).text_value.should_eql @alts[1]
  end
  
  specify "returns the results of the third alternative if it succeeds" do
    @choice.parse_at(@alts[2], 0, parser_with_empty_cache_mock).text_value.should_eql @alts[2]
  end
  
  specify "fails if no alternative succeeds" do
    nonmatching_input = "bonk"
    @choice.parse_at(nonmatching_input, 0, parser_with_empty_cache_mock).should_be_failure
  end
  
  specify "has a string representation" do
    @choice.to_s.should == '("foo" / "bar" / "baz")'
  end
end