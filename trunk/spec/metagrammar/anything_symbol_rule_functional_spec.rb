require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the anything_symbol rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:anything_symbol)
  end

  specify "parses . as an AnythingSymbol" do
    char_class = @parser.parse('.').value
    char_class.should_be_an_instance_of AnythingSymbol
  end
end