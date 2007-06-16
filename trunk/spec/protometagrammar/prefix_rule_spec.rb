dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/protometagrammar_spec_helper"

describe "The subset of the metagrammar rooted at the prefix rule" do
  include ProtometagrammarSpecContextHelper
  
  before do
    @root = :prefix
  end

  it "parses an & as a node that can modify the semantics of an expression it precedes appropriately" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse('&')
    
      parsing_expression = mock('expression following the prefix')
      and_predicate = mock('&-predicated parsing expression')
      parsing_expression.should_receive(:and_predicate).and_return(and_predicate)
    
      result.value(parsing_expression).should == and_predicate
    end
  end

  it "parses an ! as a node that can modify the semantics of an expression it precedes appropriately" do
    with_protometagrammar(@root) do |parser|
      result = parser.parse('!')
    
      parsing_expression = mock('expression following the prefix')
      not_predicate = mock('!-predicated parsing expression')
      parsing_expression.should_receive(:not_predicate).and_return(not_predicate)
    
      result.value(parsing_expression).should == not_predicate
    end
  end
end
