require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The subset of the metagrammar rooted at the character_class rule" do
  include MetagrammarSpecContextHelper
  
  before do
    @root = :character_class
  end

  it "parses a bracketed string as a CharacterClass" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('[A-C123\]]')
      result.should be_success
      
      char_class = result.value
      char_class.should be_an_instance_of(CharacterClass)
    
      parser = parser_with_empty_cache_mock
      char_class.parse_at('A', 0, parser).should be_success
      char_class.parse_at('B', 0, parser).should be_success
      char_class.parse_at('C', 0, parser).should be_success
      char_class.parse_at('1', 0, parser).should be_success
      char_class.parse_at('2', 0, parser).should be_success
      char_class.parse_at('3', 0, parser).should be_success
      char_class.parse_at(']', 0, parser).should be_success
    end
  end
end