require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/spec_helper"

context "A new parser" do
  setup do
    @grammar = Grammar.new
    @parser = @grammar.new_parser
  end
  
  specify "retains a reference to the grammar it parses" do
    @parser.grammar.should_equal(@grammar)
  end  
end