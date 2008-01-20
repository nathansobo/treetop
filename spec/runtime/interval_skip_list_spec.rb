require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")
require File.expand_path("#{File.dirname(__FILE__)}/interval_skip_list_spec_helper")

class IntervalSkipList
  public :insert_node, :delete, :head, :nodes
end

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

describe IntervalSkipList, " when #next_node_height returns 2, 3, 2, 3, 1 in order" do
  attr_reader :list, :node
  include IntervalSkipListSpecHelper

  before do
    @list = IntervalSkipList.new
  end

  it_should_behave_like "#next_node_height is deterministic"

  def expected_node_heights
    [2, 3, 2, 3, 1]
  end

  def confirm_containing_intervals(range, *markers)
    (range.begin).upto(range.end) do |i|
      list.containing(i).should have_markers(*markers)
    end
  end

  describe ", when :a is inserted on 1..7" do
    before do
      list.insert(1..7, :a)
    end

    describe ", #containing" do
      it "returns only :a from 2 through 6" do
        (2..6).should contain_marker(:a)
      end

      it "returns nothing at 1 and 7" do
        list.containing(1).should be_empty
        list.containing(7).should be_empty
      end
    end

    describe " #nodes[0]" do
      before do
        @node = list.nodes[0]
      end

      it "has a key of 1 and height of 2" do
        node.key.should == 1
        node.height.should == 2
      end

      it "has :a as its only marker at level 1" do
        node.markers[1].should have_marker(:a)
      end

      it "has no markers at level 0" do
        node.markers[0].should be_empty
      end

      it "has no eq_markers" do
        node.eq_markers.should be_empty
      end
    end

    describe " #nodes[1]" do
      before do
        @node = list.nodes[1]
      end

      it "has a key of 7 and height of 3" do
        node.key.should == 7
        node.height.should == 3
      end

      it "has no markers at any level" do
        node.markers[0].should be_empty
        node.markers[1].should be_empty
        node.markers[2].should be_empty
      end

      it "has :a as its only eq_marker" do
        node.eq_markers.should have_marker(:a)
      end
    end

    describe ", and then :b is inserted on 1..5" do
      before do
        list.insert(1..5, :b)
      end

      describe ", #containing" do
        it "returns only :a and :b from 2 through 4" do
          (2..4).should contain_markers(:a, :b)
        end

        it "returns only :a from 5 through 6" do
          pending
          (5..6).should contain_marker(:a)
        end
        
        it "returns nothing at 1 and 7" do
          list.containing(1).should be_empty
          list.containing(7).should be_empty
        end
      end

      describe " #nodes[0]" do
        before do
          @node = list.nodes[0]
        end

        it "has a key of 1 and height of 2" do
          node.key.should == 1
          node.height.should == 2
        end

        it "has :a and :b as its only markers at level 1" do
          node.markers[1].should have_markers(:a, :b)
        end

        it "has no markers at level 0" do
          node.markers[0].should be_empty
        end

        it "has no eq_markers" do
          node.eq_markers.should be_empty
        end
      end

      describe " #nodes[1]" do
        before do
          @node = list.nodes[1]
        end

        it "has a key of 5 and height of 2" do
          node.key.should == 5
          node.height.should == 2
        end

        it "has :a as its only marker at level 1" do
          node.markers[1].should have_marker(:a)
        end

        it "has no markers at level 0" do
          node.markers[0].should be_empty
        end

        it "has :a and :b as its only eq_markers" do
          node.eq_markers.should have_markers(:a, :b)
        end
      end

      describe " #nodes[2]" do
        before do
          @node = list.nodes[2]
        end

        it "has a key of 7 and height of 3" do
          node.key.should == 7
          node.height.should == 3
        end

        it "has no markers at any level" do
          node.markers[0].should be_empty
          node.markers[1].should be_empty
          node.markers[2].should be_empty
        end

        it "has :a its only eq_marker" do
          node.eq_markers.should have_marker(:a)
        end
      end

      describe ", and then :c is inserted on 1..3" do
        before do
          list.insert(1..3, :c)
        end

        describe " #nodes[0]" do
          before do
            @node = list.nodes[0]
          end

          it "has a key of 1 and height of 2" do
            node.key.should == 1
            node.height.should == 2
          end

          it "has :a, :b, :c as its only markers at level 1" do
            node.markers[1].should have_markers(:a, :b, :c)
          end

          it "has no markers at level 0" do
            node.markers[0].should be_empty
          end

          it "has no eq_markers" do
            node.eq_markers.should be_empty
          end
        end

        describe " #nodes[1]" do
          before do
            @node = list.nodes[1]
          end

          it "has a key of 3 and height of 3" do
            node.key.should == 3
            node.height.should == 3
          end

          it "has :a as its only marker at level 2" do
            node.markers[2].should have_marker(:a)
          end

          it "has :b as its only marker at level 1" do
            node.markers[1].should have_marker(:b)
          end
          
          it "has no markers at level 0" do
            node.markers[0].should be_empty
          end

          it "has :a, :b, and :c as its only eq_markers" do
            node.eq_markers.should have_markers(:a, :b, :c)
          end
        end

        describe " #nodes[2]" do
          before do
            @node = list.nodes[2]
          end

          it "has a key of 5 and height of 2" do
            node.key.should == 5
            node.height.should == 2
          end

          it "has no markers at any level" do
            node.markers[0].should be_empty
            node.markers[1].should be_empty
          end

          it "has :b as its only eq_markers" do
            node.eq_markers.should have_marker(:b)
          end
        end

        describe " #nodes[3]" do
          before do
            @node = list.nodes[3]
          end

          it "has a key of 7 and height of 3" do
            node.key.should == 7
            node.height.should == 3
          end

          it "has no markers at any level" do
            node.markers[0].should be_empty
            node.markers[1].should be_empty
            node.markers[2].should be_empty
          end

          it "has :a as its only eq_marker" do
            node.eq_markers.should have_marker(:a)
          end
        end

        describe ", and then :d is inserted on 1..9" do
          before do
            list.insert(1..9, :d)
          end

          describe " #nodes[0]" do
            before do
              @node = list.nodes[0]
            end

            it "has a key of 1 and height of 2" do
              node.key.should == 1
              node.height.should == 2
            end

            it "has :a, :b, :c, :d as its only markers at level 1" do
              node.markers[1].should have_markers(:a, :b, :c, :d)
            end

            it "has no markers at level 0" do
              node.markers[0].should be_empty
            end

            it "has no eq_markers" do
              node.eq_markers.should be_empty
            end
          end

          describe " #nodes[1]" do
            before do
              @node = list.nodes[1]
            end

            it "has a key of 3 and height of 3" do
              node.key.should == 3
              node.height.should == 3
            end

            it "has :a and :d as its only markers at level 2" do
              node.markers[2].should have_markers(:a, :d)
            end

            it "has :b as its only marker at level 1" do
              node.markers[1].should have_marker(:b)
            end

            it "has no markers at level 0" do
              node.markers[0].should be_empty
            end

            it "has :a, :b, :c, :d as its only eq_markers" do
              node.eq_markers.should have_markers(:a, :b, :c, :d)
            end
          end

          describe " #nodes[2]" do
            before do
              @node = list.nodes[2]
            end

            it "has a key of 5 and height of 2" do
              node.key.should == 5
              node.height.should == 2
            end

            it "has no markers on any level" do
              node.markers[0].should be_empty
              node.markers[1].should be_empty
            end

            it "has :b as its only eq_marker" do
              node.eq_markers.should have_marker(:b)
            end
          end

          describe " #nodes[3]" do
            before do
              @node = list.nodes[3]
            end

            it "has a key of 7 and height of 3" do
              node.key.should == 7
              node.height.should == 3
            end

            it "has :d as its only marker at level 0" do
              node.markers[0].should have_marker(:d)
            end

            it "has no markers at levels 1 and 2" do
              node.markers[1].should be_empty
              node.markers[2].should be_empty
            end

            it "has :a, :d as its only eq_markers" do
              node.eq_markers.should have_markers(:a, :d)
            end
          end

          describe " #nodes[4]" do
            before do
              @node = list.nodes[4]
            end

            it "has a key of 9 and height of 1" do
              node.key.should == 9
              node.height.should == 1
            end

            it "has no markers at level 0" do
              node.markers[0].should be_empty
            end

            it "has :d as its only eq_marker" do
              node.eq_markers.should have_marker(:d)
            end
          end
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
  describe HeadNode do
    it "instantiated a forward array of nils of size equal to its height" do
      node = HeadNode.new(3)
      node.forward.should == [nil, nil, nil]
    end
  end
end