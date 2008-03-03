require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module SyntaxNodeSpec
  include Runtime

  describe "A new terminal syntax node" do
    attr_reader :node

    before do
      @node = SyntaxNode.new("input", 0...3)
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

  describe "A new nonterminal syntax node instantiated with a SyntaxNode and a Propagation as its children" do
    attr_reader :input, :child_node, :propagated_node, :elements, :node

    before do
      input = 'input'
      @child_node = SyntaxNode.new(input, 0...3)
      @propagated_node = SyntaxNode.new(input, 3...5)
      @node = SyntaxNode.new(input, 0...5, [child_node, Propagation.new(propagated_node)])
    end

    it "reports itself as nonterminal" do
      node.should be_nonterminal
      node.should_not be_terminal
    end
  
    it "has a text value based on the input and the interval" do
      node.text_value.should == "input"
    end
  
    it "eliminates the Propagation from its #elements" do
      node.elements.should == [child_node, propagated_node]
    end

    it "sets itself as the parent of its elements" do
      node.elements.each do |element|
        element.parent.should == node
      end
    end

    it "reports the end of its interval as its #resume_index" do
      node.resume_index.should == 5
    end
    
    it "does not report itself as epsilon if its interval isn't epsilon" do
      node.should_not be_epsilon
    end
  end
  
  describe "A new epsilon syntax node" do
    attr_reader :node
    
    before do
      @node = SyntaxNode.new('input', 4..4)
    end
    
    it "reports itself as epsilon" do
      node.should be_epsilon
    end
  end
end
