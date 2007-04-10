require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the parsing_rule_sequence rule" do
  include MetagrammarSpecContextHelper

  setup do
    @root = :parsing_rule_sequence
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:parsing_rule_sequence)
  end
  
  specify "parses a single rule" do
    with_both_protometagrammar_and_metagrammar do
      input = "rule foo bar end"
    
      result = @parser.parse(input)
      result.should be_success      
      
      grammar = Grammar.new
      rules = result.value(grammar)
      
      rules[0].should be_an_instance_of(ParsingRule)
    end
  end
  
  specify "parses two rules" do
    with_both_protometagrammar_and_metagrammar do
      input = "rule foo bar end rule baz bop end"
    
      result = @parser.parse(input)
      result.should be_success
      
      grammar = Grammar.new
      rules = result.value(grammar)
      
      rules.each do |rule|
        rule.should be_an_instance_of(ParsingRule)
      end
    end
  end
end