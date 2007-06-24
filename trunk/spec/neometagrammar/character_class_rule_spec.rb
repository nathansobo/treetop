dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/neometagrammar_spec_context_helper"

describe "A parser for the subset of the metagrammar rooted at the character_class rule" do
  include NeometagrammarSpecContextHelper

  before(:all) do
    set_metagrammar_root(:character_class)
    @parser = parser_for_metagrammar
  end
  
  after(:all) do
    reset_metagrammar_root
  end
  
  it "successfully parses and generates Ruby for '[A-C123\\]]'" do
    result = @parser.parse('[A-C123\]]')
    result.should be_success
    value = eval(result.to_ruby)
    
    value.should be_an_instance_of(CharacterClass)
    value.parse_at('A', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at('B', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at('C', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at('1', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at('2', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at('3', 0, parser_with_empty_cache_mock).should be_success
    value.parse_at(']', 0, parser_with_empty_cache_mock).should be_success
  end
end