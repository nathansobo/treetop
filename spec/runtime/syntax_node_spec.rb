require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module SyntaxNodeSpec
  describe "A new terminal syntax node" do
    attr_reader :node

    before do
      @node = Runtime::SyntaxNode.new("input", 0...3)
    end
  
    it "reports itself as terminal" do
      node.should be_terminal
      node.should_not be_nonterminal
    end

    it "has an empty dependencies array" do
      node.dependencies.should == []
    end
  
    it "has a text value based on the input and the interval" do
      node.text_value.should == "inp"
    end
  
    it "reports the end of its interval as its #resume_index" do
      node.resume_index.should == 3
    end
  end

  describe "A new nonterminal syntax node" do
    attr_reader :node

    before do
      @input = 'test input'
      @elements = [Runtime::SyntaxNode.new('input', 0...3)]
      @node = Runtime::SyntaxNode.new('input', 0...3, @elements)
    end

    it "reports itself as nonterminal" do
      node.should be_nonterminal
      node.should_not be_terminal
    end
  
    it "has a text value based on the input and the interval" do
      node.text_value.should == "inp"
    end
  
    it "has the elements with which it was instantiated" do
      node.elements.should == @elements
    end

    it "sets itself as the parent of its elements" do
      node.elements.each do |element|
        element.parent.should == node
      end
    end

    it "reports the end of its interval as its #resume_index" do
      node.resume_index.should == 3
    end
    
    it "does not report itself as epsilon if its interval isn't epsilon" do
      node.should_not be_epsilon
    end
  end
  
  describe "A new epsilon syntax node" do
    attr_reader :node
    
    before do
      @node = Runtime::SyntaxNode.new('input', 4..4)
    end
    
    it "reports itself as epsilon" do
      node.should be_epsilon
    end
  end
end
