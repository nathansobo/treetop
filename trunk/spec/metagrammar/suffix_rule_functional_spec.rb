require 'rubygems'
require 'spec/runner'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the suffix rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @metagrammar = Protometagrammar.new
    @parser = @metagrammar.new_parser
    @metagrammar.root = @metagrammar.nonterminal_symbol(:suffix)
  end

  specify "parses a * to a node that can modify the semantics of an expression it follows appropriately" do
    result = @parser.parse('*')
    
    parsing_expression = mock('expression preceding the suffix')
    zero_or_more = mock('zero or more of the parsing expression')
    parsing_expression.should_receive(:zero_or_more).and_return(zero_or_more)
    
    result.value(parsing_expression).should == zero_or_more
  end

  specify "parses a + node that can modify the semantics of an expression it follows appropriately" do
    result = @parser.parse('+')
    
    parsing_expression = mock('expression preceding the suffix')
    one_or_more = mock('one or more of the parsing expression')
    parsing_expression.should_receive(:one_or_more).and_return(one_or_more)
    
    result.value(parsing_expression).should == one_or_more
  end

  specify "parses a ? node that can modify the semantics of an expression it follows appropriately" do
    result = @parser.parse('?')
    
    parsing_expression = mock('expression preceding the suffix')
    optional = mock('optional parsing expression')
    parsing_expression.should_receive(:optional).and_return(optional)
    
    result.value(parsing_expression).should == optional
  end
end