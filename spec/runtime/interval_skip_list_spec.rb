require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

describe "#next_node_height is deterministic", :shared => true do
  before do
    node_heights = expected_node_heights.dup
    stub(list).next_node_height { node_heights.shift }
  end
end

describe "it is non-empty", :shared => true do
  specify "#empty? returns false" do
    list.should_not be_empty
  end
end

describe "#nodes is an array of the three inserted nodes in key order", :shared => true do
  specify "#nodes is an array of the three inserted nodes in key order" do
    list.nodes.should == inserted_nodes.sort_by(&:key)
  end
end

describe "it has nil forward pointers", :shared => true do
  it "has nil forward pointers" do
    inserted_node.forward.each do |next_pointer|
      next_pointer.should be_nil
    end
  end
end

describe IntervalSkipList do
  attr_reader :list

  before do
    @list = IntervalSkipList.new
  end

  describe " when :a is inserted for interval 1..5" do
    def expected_node_heights
      [1,2]
    end

    it_should_behave_like "#next_node_height is deterministic"

    before do
      list.insert(1..5, :a)
    end

    describe "first node" do
      attr_reader :node

      before do
        @node = list.nodes[0]
      end

      it "has a key of 1" do
        node.key.should == 1
      end

      it "has a height of 1" do
        node.height.should == 1
      end

      it "has :a as its sole value at level 0" do
        node.values[0].should == [:a]
      end
    end

    describe "second node" do
      attr_reader :node

      before do
        @node = list.nodes[1]
      end

      it "has a key of 5" do
        node.key.should == 5
      end

      it "has a height of 2" do
        node.height.should == 2
      end

      it "has :a as its sole eq_value" do
        node.eq_values.should == [:a]
      end
    end
  end  

  describe " when :a is inserted for interval 1..5 and :b is inserted for interval 2..6" do
    it_should_behave_like "#next_node_height is deterministic"

    before do
      list.insert(1..5, :a)
      list.insert(2..6, :b)
    end

    describe "when next_node_height returns 1, 1, 1, 1" do
      attr_reader :node

      def expected_node_heights
        [1, 1, 1, 1]
      end

      describe " #nodes[0]" do
        before do
          @node = list.nodes[0]
        end

        it "has a key of 1 and a height of 1" do
          node.key.should == 1
          node.height.should == 1
        end

        it "has :a as its sole value at level 0" do
          node.values[0].should == [:a]
        end
      end

      describe " #nodes[1]" do
        before do
          @node = list.nodes[1]
        end

        it "has a key of 2 and a height of 1" do
          node.key.should == 2
          node.height.should == 1
        end

        it "has values :a and :b at level 0" do
          values = node.values[0]
          values.size.should == 2
          values.should include(:a)
          values.should include(:b)
        end

        it "has :a as its sole eq_value" do
          node.eq_values.should == [:a]
        end
      end

      describe " #nodes[2]" do
        before do
          @node = list.nodes[2]
        end

        it "has a key of 5 and a height of 1" do
          node.key.should == 5
          node.height.should == 1
        end

        it "has :b as its sole value at level 0" do
          node.values[0].should == [:b]
        end

        it "has :a and :b as its eq_values" do
          eq_values = node.eq_values
          eq_values.size.should == 2
          eq_values.should include(:a)
          eq_values.should include(:b)
        end
      end

      describe " #nodes[3]" do
        before do
          @node = list.nodes[3]
        end

        it "has a key of 6 and a height of 1" do
          node.key.should == 6
          node.height.should == 1
        end

        it "has no values at level 0" do
          node.values[0].should be_empty
        end

        it "has :b as its sole eq_value" do
          node.eq_values.should == [:b]
        end
      end
    end

    describe "when next_node_height returns 1, 2, 3, 3 in order" do
      attr_reader :node

      def expected_node_heights
        [1, 2, 3, 3]
      end

      describe " #nodes[0]" do
        before do
          @node = list.nodes[0]
        end

        it "has a key of 1 and a height of 1" do
          node.key.should == 1
          node.height.should == 1
        end

        it "has :a as its sole value at level 0" do
          node.values[0].should == [:a]
        end
      end

      describe " #nodes[1]" do
        before do
          @node = list.nodes[1]
        end

        it "has a key of 2 and a height of 3" do
          node.key.should == 2
          node.height.should == 3
        end

        it "has :b as its sole value at level 2" do
          node.values[2].should == [:b]
        end

        it "has :a as its sole value at level 1" do
          node.values[1].should == [:a]
        end

        it "has no values at level 0" do
          node.values[0].should be_empty
        end

        it "has :a as its sole eq_value" do
          node.eq_values.should == [:a]
        end
      end

      describe " #nodes[2]" do
        before do
          @node = list.nodes[2]
        end

        it "has a key of 5 and a height of 2" do
          node.key.should == 5
          node.height.should == 2
        end

        it "has :a as its sole eq_value" do
          node.eq_values.should == [:a]
        end
      end

      describe " #nodes[3]" do
        before do
          @node = list.nodes[3]
        end

        it "has a key of 6 and a height of 3" do
          node.key.should == 6
          node.height.should == 3
        end

        it "has :b as its sole eq_value" do
          node.eq_values.should == [:b]
        end
      end
    end
  end

  # Node insertion

  describe " when nothing has been inserted" do
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

      it "has nil forward pointers" do
        0.upto(list.max_height - 1) do |i|
          head.forward[i].should be_nil
        end
      end
    end
  end

  describe " when 1 has been inserted" do
    attr_reader :inserted_node, :inserted_nodes

    def expected_node_heights
      [1]
    end

    it_should_behave_like "#next_node_height is deterministic"

    before do
      @inserted_node = list.insert_node(1)
      @inserted_nodes = [@inserted_node]
    end

    it_should_behave_like "it is non-empty"
    it_should_behave_like "#nodes is an array of the three inserted nodes in key order"

    describe "#head" do
      attr_reader :head

      before do
        @head = list.head
      end

      it "has inserted_node.height forward pointers pointing at the inserted node" do
        0.upto(inserted_node.height - 1) do |i|
          head.forward[i].should == inserted_node
        end
      end

      it "has the rest of its forward pointers pointing at nil" do
        inserted_node.height.upto(list.max_height - 1) do |i|
          head.forward[i].should == nil
        end
      end
    end

    describe "the inserted node" do
      it_should_behave_like "it has nil forward pointers"

      it "has a height of the expected_node_heights.first" do
        inserted_node.height.should == expected_node_heights.first
      end

      it "has a key of 1" do
        inserted_node.key.should == 1
      end
    end

    describe "and subsequently deleted" do
      before do
        list.delete(1)
      end

      specify "#empty? returns true" do
        list.should be_empty
      end
    end
  end

  describe " when 1 and 3 have been inserted in order" do
    attr_reader :inserted_nodes

    def expected_node_heights
      [1, 2]
    end

    it_should_behave_like "#next_node_height is deterministic"

    before do
      @inserted_nodes = []
      inserted_nodes << list.insert_node(1)
      inserted_nodes << list.insert_node(3)
    end

    it_should_behave_like "it is non-empty"
    it_should_behave_like "#nodes is an array of the three inserted nodes in key order"

    describe "the first inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[0]
      end

      it "has a key of 1" do
        inserted_node.key.should == 1
      end

      it "has a height of the first expected node height" do
        inserted_node.height.should == expected_node_heights[0]
      end

      it "has its single forward pointer pointing at the second inserted node" do
        inserted_node.forward[0].should == inserted_nodes[1]
      end
    end

    describe "the second inserted node" do
      attr_reader :inserted_node
      
      before do
        @inserted_node = inserted_nodes[1]
      end

      it_should_behave_like "it has nil forward pointers"

      it "has a key of 3" do
        inserted_node.key.should == 3
      end

      it "has a height of the second expected node height" do
        inserted_node.height.should == expected_node_heights[1]
      end
    end

    describe "and 1 is subsequently deleted" do
      before do
        list.delete(1)
      end

      describe "the remaining node" do
        attr_reader :inserted_node

        before do
          @inserted_node = inserted_nodes[1]
        end

        it "is the first node in the list" do
          inserted_node.should == list.nodes[0]
        end

        it_should_behave_like "it has nil forward pointers"
      end
    end

    describe "and 3 is subsequently deleted" do
      before do
        list.delete(3)
      end

      describe "the remaining node" do
        attr_reader :inserted_node

        before do
          @inserted_node = inserted_nodes[0]
        end

        it "is the first node in the list" do
          inserted_node.should == list.nodes[0]
        end

        it_should_behave_like "it has nil forward pointers"
      end
    end
  end

  describe " when 1, 3 and 7 have been inserted in order" do
    attr_reader :inserted_nodes

    def expected_node_heights
      [1, 2, 1]
    end

    it_should_behave_like "#next_node_height is deterministic"

    before do
      @inserted_nodes = []
      inserted_nodes << list.insert_node(1)
      inserted_nodes << list.insert_node(3)
      inserted_nodes << list.insert_node(7)
    end

    it_should_behave_like "it is non-empty"
    it_should_behave_like "#nodes is an array of the three inserted nodes in key order"

    describe "the first inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[0]
      end

      it "has a key of 1" do
        inserted_node.key.should == 1
      end

      it "has a height of the first expected node height" do
        inserted_node.height.should == expected_node_heights[0]
      end

      it "has its single forward pointer pointing at the second inserted node" do
        inserted_node.forward[0].should == inserted_nodes[1]
      end
    end

    describe "the second inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[1]
      end

      it "has a key of 3" do
        inserted_node.key.should == 3
      end

      it "has a height of the second expected node height" do
        inserted_node.height.should == expected_node_heights[1]
      end

      it "has a forward pointer at level 0 pointing to the third inserted node" do
        inserted_node.forward[0].should == inserted_nodes[2]
      end

      it "has nil forward pointer at level 1" do
        inserted_node.forward[1].should be_nil
      end
    end

    describe "the third inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[2]
      end

      it_should_behave_like "it has nil forward pointers"

      it "has a key of 3" do
        inserted_node.key.should == 7
      end

      it "has a height of the third expected node height" do
        inserted_node.height.should == expected_node_heights[2]
      end
    end

    describe "and 3 is subsequently deleted" do
      before do
        list.delete(3)
      end

      specify "#head points at nil at levels 1 and 2" do
        list.head.forward[1].should be_nil
        list.head.forward[2].should be_nil
      end

      specify "#nodes contains the remaining nodes in order" do
        list.nodes.should == [inserted_nodes[0], inserted_nodes[2]]
      end
    end
  end

  describe " when 7, 1 and 3 have been inserted in order" do
    attr_reader :inserted_nodes

    def expected_node_heights
      [1, 1, 2]
    end

    it_should_behave_like "#next_node_height is deterministic"

    before do
      @inserted_nodes = []
      inserted_nodes << list.insert_node(7)
      inserted_nodes << list.insert_node(1)
      inserted_nodes << list.insert_node(3)
    end

    it_should_behave_like "it is non-empty"
    it_should_behave_like "#nodes is an array of the three inserted nodes in key order"

    describe "the first inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[0]
      end

      it_should_behave_like "it has nil forward pointers"

      it "has a key of 7" do
        inserted_node.key.should == 7
      end

      it "has a height of the first expected node height" do
        inserted_node.height.should == expected_node_heights[0]
      end
    end

    describe "the second inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[1]
      end

      it "has a key of 1" do
        inserted_node.key.should == 1
      end

      it "has a height of the second expected node height" do
        inserted_node.height.should == expected_node_heights[1]
      end

      it "has a forward pointer at level 0 pointing to the second node in the list" do
        inserted_node.forward[0].should == list.nodes[1]
      end
    end

    describe "the third inserted node" do
      attr_reader :inserted_node

      before do
        @inserted_node = inserted_nodes[2]
      end

      it "has a key of 3" do
        inserted_node.key.should == 3
      end

      it "has a height of the third expected node height" do
        inserted_node.height.should == expected_node_heights[2]
      end
    end
  end
end

class IntervalSkipList
  describe Node do
    it "instantiated a forward array of nils of size equal to its height" do
      node = Node.new(nil, 3)
      node.forward.should == [nil, nil, nil]
    end
  end
end