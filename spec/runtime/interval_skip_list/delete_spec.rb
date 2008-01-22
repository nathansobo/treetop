require File.expand_path("#{File.dirname(__FILE__)}/../../spec_helper")
require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

class IntervalSkipList
  public :insert_node, :delete_node, :head, :nodes
end

describe IntervalSkipList, " with nodes of height 1, 3, 1, 2, 3" do
  attr_reader :list, :node
  include IntervalSkipListSpecHelper

  before do
    @list = IntervalSkipList.new
  end

  it_should_behave_like "#next_node_height is deterministic"
  def expected_node_heights
    [1, 3, 1, 2, 3]
  end

  before do
    list.insert(1..3, :b)
    list.insert(1..5, :c)
    list.insert(1..7, :d)
    list.insert(1..9, :a)
  end

  describe " nodes[0]" do
    before do
      @node = list.nodes[0]
    end

    it "has a key of 1 and a height of 1" do
      node.key.should == 1
      node.height.should == 1
    end
  end

  describe " nodes[1]" do
    before do
      @node = list.nodes[1]
    end

    it "has a key of 3 and a height of 3" do
      node.key.should == 3
      node.height.should == 3
    end
  end

  describe " nodes[2]" do
    before do
      @node = list.nodes[2]
    end

    it "has a key of 5 and a height of 1" do
      node.key.should == 5
      node.height.should == 1
    end
  end

  describe " nodes[3]" do
    before do
      @node = list.nodes[3]
    end

    it "has a key of 7 and a height of 2" do
      node.key.should == 7
      node.height.should == 2
    end
  end

  describe " nodes[4]" do
    before do
      @node = list.nodes[4]
    end

    it "has a key of 9 and a height of 3" do
      node.key.should == 9
      node.height.should == 3
    end
  end
  
end