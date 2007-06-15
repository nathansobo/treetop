dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"
require "#{dir}/metagrammar_spec_context_helper"

describe "The node returned by the prefix rule's successful parsing of '&'" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:prefix) do |parser|
      @node = parser.parse('&')
    end
  end
  
  it "has a Ruby source representation given the source for the expression being predicated" do
    subsequent_expression_ruby = "TerminalSymbol.new('foo')"
    @node.to_ruby(subsequent_expression_ruby).should == "AndPredicate.new(#{subsequent_expression_ruby})"
  end
end

describe "The node returned by the prefix rule's successful parsing of '!'" do
  include MetagrammarSpecContextHelper
  
  before do
    with_metagrammar(:prefix) do |parser|
      @node = parser.parse('!')
    end
  end
  
  it "has a Ruby source representation given the source for the expression being predicated" do
    subsequent_expression_ruby = "TerminalSymbol.new('foo')"
    @node.to_ruby(subsequent_expression_ruby).should == "NotPredicate.new(#{subsequent_expression_ruby})"
  end
end
