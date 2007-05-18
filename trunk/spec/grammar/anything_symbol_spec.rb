require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "An anything symbol (.)" do
  setup do
    @anything = AnythingSymbol.new
  end
  
  # warning: this spec may not actually enumerate every possible character
  it "matches any single character" do
    (33..127).each do |digit|
      char = digit.chr
      @anything.parse_at(char, 0, parser_with_empty_cache_mock).should be_a_success
    end
  end
  
  it "has a string representation" do
    @anything.to_s.should == '.'
  end
  
  it "returns a ParseFailure" do
    result = @anything.parse_at('', 0, parser_with_empty_cache_mock)
    result.should be_an_instance_of(ParseFailure)
  end
  
  it "parses a newline" do
    @anything.parse_at("\n", 0, parser_with_empty_cache_mock).should be_success
  end
end