require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the parsing_rule rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:parsing_rule)
  end
  
  specify "parses a parse rule with a terminal symbol as its expression" do
    result = parse_result_for("rule foo 'bar' end")
   
    result.should be_an_instance_of(ParsingRule)
    result.nonterminal_symbol.name.should == :foo
    result.parsing_expression.should be_an_instance_of(TerminalSymbol)
  end

  specify "parses a parse rule with a nasty fucking expression" do
    result = parse_result_for("rule foo 'bar' baz+ (xyzzy / plugh*) !bar end")
   
    result.should be_an_instance_of(ParsingRule)
  end
end
