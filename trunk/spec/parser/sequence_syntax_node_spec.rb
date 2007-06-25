dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A SequenceSyntaxNode" do
  before do
    @expression = mock('expression')
    @elements = mock('elements')
    @sequence_node = SequenceSyntaxNode.new(@expression, "input", 0...5, @elements, [])
  end
  
  it "retains a reference to its elements" do
    @sequence_node.elements.should ==@elements
  end
  
  it "retains a reference to the expression that instantiated it" do
    @sequence_node.expression.should == @expression
  end
  
end