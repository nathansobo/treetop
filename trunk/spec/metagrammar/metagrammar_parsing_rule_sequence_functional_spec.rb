require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the parsing_rule_sequence rule" do
  include MetagrammarSpecContextHelper

  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:parsing_rule_sequence)
  end
  
  specify "parses a single rule" do
    input = "rule foo bar end"
    
    result = @parser.parse(input)
    result.should be_success
  end
  
  specify "parses two rules" do
    input = "rule foo bar end rule baz bop end"
    
    result = @parser.parse(input)
    result.should be_success
  end
end