require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

context "The subset of the metagrammar rooted at the prefix rule" do
  include MetagrammarSpecContextHelper
  
  setup do
    @root = :prefix
  end

  specify "parses an & as a node that can modify the semantics of an expression it precedes appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('&')
    
      parsing_expression = mock('expression following the prefix')
      and_predicate = mock('&-predicated parsing expression')
      parsing_expression.should_receive(:and_predicate).and_return(and_predicate)
    
      result.value(parsing_expression).should == and_predicate
    end
  end

  specify "parses an ! as a node that can modify the semantics of an expression it precedes appropriately" do
    with_both_protometagrammar_and_metagrammar(@root) do |parser|
      result = parser.parse('!')
    
      parsing_expression = mock('expression following the prefix')
      not_predicate = mock('!-predicated parsing expression')
      parsing_expression.should_receive(:not_predicate).and_return(not_predicate)
    
      result.value(parsing_expression).should == not_predicate
    end
  end
end