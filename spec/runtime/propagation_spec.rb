require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module PropagationSpec
  include Runtime

  describe "A new Propagation" do
    attr_reader :propagated_syntax_node, :propagation

    before do
      @propagated_syntax_node = SyntaxNode.new("input", 0...5)
      @propagation = Propagation.new(propagated_syntax_node)
    end

    it "returns the SyntaxNode with which it was instantiated with as its element" do
      propagation.element.should == propagated_syntax_node
    end

    it "returns the propagated SyntaxNode as its only dependency" do
      propagation.dependencies.should == [propagated_syntax_node]
    end

    it "proxies #resume_index to its element" do
      propagation.resume_index.should == propagated_syntax_node.resume_index
    end

    it "proxies #epsilon? to its element" do
      mock.proxy(propagated_syntax_node).epsilon?
      propagation.epsilon?
    end
  end

  describe "A new Propagation instantiated with an epsilon result" do
    attr_reader :epsilon, :propagation
    before do
      @epsilon = SyntaxNode.new('input', 3...3)
      @propagation = Propagation.new(epsilon)
    end

    it "includes its endpoint to reflect a dependency on this buffer site that isn't shared by the propagated node" do
      propagation.interval.should == (epsilon.interval.first..epsilon.interval.last)
    end
  end
end