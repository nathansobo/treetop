require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the character_class rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:character_class)
  end

  specify "parses a bracketed string as a CharacterClass" do
    char_class = @parser.parse('[A-C123\\]]').value
    char_class.should_be_an_instance_of CharacterClass
    
    parser = parser_with_empty_cache_mock
    char_class.parse_at('A', 0, parser).should_be_success
    char_class.parse_at('B', 0, parser).should_be_success
    char_class.parse_at('C', 0, parser).should_be_success
    char_class.parse_at('1', 0, parser).should_be_success
    char_class.parse_at('2', 0, parser).should_be_success
    char_class.parse_at('3', 0, parser).should_be_success
    char_class.parse_at(']', 0, parser).should_be_success    
  end
end