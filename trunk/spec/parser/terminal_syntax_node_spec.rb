dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe "A terminal syntax node" do
  before do
    @expression = mock('expression')
    input = "foobar"
    interval = 0...3
    @node = TerminalSyntaxNode.new(@expression, input, interval)
  end
  
  it "has the text value of the input over its interval " do
    @node.text_value.should == "foo"
  end  
  
  it "remembers the expression that instantiated it" do
    @node.expression.should == @expression
  end
end

describe "An empty terminal syntax node" do
  before do
    input = ""
    interval = 0...0
    @node = TerminalSyntaxNode.new(mock('expression'), input, interval)
  end
  
  it "should be epsilon" do
    @node.should be_epsilon
  end
end