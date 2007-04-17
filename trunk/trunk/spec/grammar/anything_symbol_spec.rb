require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

context "An anything symbol (.)" do
  setup do
    @anything = AnythingSymbol.new
  end
  
  # warning: this spec may not actually enumerate every possible character
  specify "matches any single character" do
    (33..127).each do |digit|
      char = digit.chr
      @anything.parse_at(char, 0, parser_with_empty_cache_mock).should be_a_success
    end
  end
  
  specify "has a string representation" do
    @anything.to_s.should == '.'
  end
  
  specify "fails with a TerminalParseFailure upon trying to parse epsilon" do
    @anything.parse_at('', 0, parser_with_empty_cache_mock).should be_an_instance_of(TerminalParseFailure)
  end
  
  specify "parses a newline" do
    @anything.parse_at("\n", 0, parser_with_empty_cache_mock).should be_success
  end
end