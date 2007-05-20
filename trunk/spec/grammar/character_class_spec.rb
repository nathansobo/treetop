require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A character class with the range A-Z" do
  before do
    @char_class = CharacterClass.new('A-Z')
  end
  
  it "matches single characters within that range" do
    @char_class.parse_at('A', 0, parser_with_empty_cache_mock).should be_success
    @char_class.parse_at('N', 0, parser_with_empty_cache_mock).should be_success
    @char_class.parse_at('Z', 0, parser_with_empty_cache_mock).should be_success    
  end
  
  it "does not match single characters outside of that range" do
    @char_class.parse_at('8', 0, parser_with_empty_cache_mock).should be_failure
    @char_class.parse_at('a', 0, parser_with_empty_cache_mock).should be_failure
  end
  
  it "has a string representation" do
    @char_class.to_s.should == '[A-Z]'
  end
  
  it "matches a single character within that range at index 1" do
    @char_class.parse_at(' A', 1, parser_with_empty_cache_mock).should be_success
  end
  
  it "fails to match a single character out of that range at index 1" do
    @char_class.parse_at(' 1', 1, parser_with_empty_cache_mock).should be_failure
  end
end