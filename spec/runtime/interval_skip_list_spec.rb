require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe "it is non-empty", :shared => true do
  specify "#empty? returns false" do
    list.should_not be_empty
  end
end

describe IntervalSkipList do
  attr_reader :list, :expected_node_heights

  before do
    @list = IntervalSkipList.new
    @expected_node_heights = [3, 1, 2, 1, 3, 1, 2, 2]
  end

  describe "when nothing has been inserted" do
    specify "#empty? returns true" do
      list.should be_empty
    end

    specify "#nodes returns an empty array" do
      list.nodes.should == []
    end

    describe "#head" do
      attr_reader :head

      before do
        @head = list.head
      end

      it "#has a height of #max_height" do
        head.height.should == list.max_height
      end

      it "has null next pointers" do
        0.upto(list.max_height - 1) do |i|
          head.next[i].should be_nil
        end
      end
    end
  end

  describe "when 1 has been inserted" do
    attr_reader :inserted_node

    before do
      list.insert(1)
      @inserted_node = list.nodes.first
    end

    it_should_behave_like "it is non-empty"

    specify "#nodes is an array of 1 node with a value of 1 and the first expected node height" do
      nodes = list.nodes
      nodes.size.should == 1
      node = nodes.first

      node.value.should == 1
      node.height.should == expected_node_heights.first
    end

    describe "#head" do
      attr_reader :head

      before do
        @head = list.head
      end

      it "has inserted_node.height next pointers pointing at the inserted node" do
        0.upto(inserted_node.height - 1) do |i|
          head.next[i].should == inserted_node
        end
      end

      it "has the rest of its next pointers pointing at nil" do
        inserted_node.height.upto(list.max_height - 1) do |i|
          head.next[i].should == nil
        end
      end
    end
  end

  describe "when 1 and 3 have been inserted" do
    before do
      list.insert(1)
      list.insert(3)
    end

    it_should_behave_like "it is non-empty"

    specify "#nodes is an array of 2 nodes with the correct values and heights" do
      nodes = list.nodes
      nodes.size.should == 2

      nodes.map(&:value).should == [1, 3]
      nodes.map(&:height).should == expected_node_heights[0..1]
    end
  end

  describe "#next_node_height" do
    it "returns a deterministic stream of random numbers for successive calls to node_height" do
      actual_heights = []

      expected_node_heights.size.times do
        actual_heights << list.send(:next_node_height)
      end
      actual_heights.should == expected_node_heights
    end
  end
end

class IntervalSkipList
  describe Node do
    it "instantiated a next array of nils of size equal to its height" do
      node = Node.new(nil, 3)
      node.next.should == [nil, nil, nil]
    end
  end
end