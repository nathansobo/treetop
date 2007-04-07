require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the space rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Metagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:space)
  end

  specify "parses different types of whitespace" do
    grammar = Grammar.new

    @parser.parse(' ').should be_success
    @parser.parse('    ').should be_success
    @parser.parse("\t\t").should be_success
    @parser.parse("\n").should be_success
  end
  
  specify "does not parse nonwhitespace characters" do
    grammar = Grammar.new
    @parser.parse('g').should be_failure
    @parser.parse('g ').should be_failure  
    @parser.parse(" crack\n").should be_failure  
    @parser.parse("\n rule foo\n bar\n end\n").should be_failure  
  end
end