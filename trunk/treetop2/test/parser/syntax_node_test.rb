dir = File.dirname(__FILE__)
require "#{dir}/../test_helper"

describe "A new terminal syntax node" do
  
  def setup
    @node = Parser::SyntaxNode.new("input", 0...3)
  end
  
  it "reports itself as terminal" do
    @node.should be_terminal
    @node.should_not be_nonterminal
  end
  
  it "has a text value based on the input and the interval" do
    @node.text_value.should == "inp"
  end
  
  it "has no nested failures" do
    @node.nested_failures.should be_empty
  end
  
  it "has itself as its only element" do
    @node.elements.should == [@node]
  end
end

describe "A new nonterminal syntax node" do
  def setup    
    @nested_results = [Parser::TerminalParseFailure.new(1, 'foo')]
    @elements = Parser::SyntaxNode.new('input', 0...3)
    @node = Parser::SyntaxNode.new('input', 0...3, @elements, @nested_results)
  end

  it "reports itself as nonterminal" do
    @node.should be_nonterminal
    @node.should_not be_terminal
  end
  
  it "has a text value based on the input and the interval" do
    @node.text_value.should == "inp"
  end
  
  it "has the elements with which it was instantiated" do
    @node.elements.should == @elements
  end
  
  it "has nested failures frow within the nested results with which it was instantiated" do
    @node.nested_failures.should == @nested_results
  end
  
end