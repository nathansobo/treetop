require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ResultCacheSpec
  include Runtime

  describe ResultCache do
    attr_reader :cache, :input

    before do
      @cache = ResultCache.new
      @input = ('A'..'Z').to_a.join
    end

    describe "with a parse result stored on a name and interval" do
      attr_reader :node

      before do
        @node = SyntaxNode.new(input, 5...10)
        cache.store_result(:foo, node)
      end

      describe "#get_result" do
        it "returns the stored result given the correct name and start index" do
          cache.get_result(:foo, 5).should == node
        end
      end

      describe "#has_result?" do
        it "returns true when given the correct name and start index" do
          cache.should have_result(:foo, 5)
        end

        it "returns false when given a different name" do
          cache.should_not have_result(:bar, 5)
        end

        it "returns false when given a different start index" do
          cache.should_not have_result(:foo, 2)
        end
      end

      describe "#expire" do
        it "deletes the stored result from the cache when expiring an exactly overlapping interval" do
          cache.should have_result(:foo, 5)
          cache.expire(5..10, 0)
          cache.should_not have_result(:foo, 5)
        end

        it "deletes the stored result from the cache when expiring a partially overlapping interval" do
          cache.should have_result(:foo, 5)
          cache.expire(8..14, 0)
          cache.should_not have_result(:foo, 5)
        end

        it "does not delete the stored result from the cache when expiring a non-overlapping interval" do
          cache.should have_result(:foo, 5)
          cache.expire(3..5, 0)
          cache.should have_result(:foo, 5)
        end
      end
    end
    
    describe "with a SyntaxNode with two terminal children stored in it" do
      attr_reader :number
      
      before do
        input = '11'
        @number = SyntaxNode.new(input, 0...2, [SyntaxNode.new(input, 0...1), SyntaxNode.new(input, 1...2)])
        cache.store_result(:number, number)
      end
      
      it "expires the storage of that node if an expiry occurs between its children" do
        cache.should have_result(:number, 0)
        cache.expire(1..1, 1)
        cache.should_not have_result(:number, 0)
      end
    end

    describe "with results for different rules stored on non-overlapping intervals" do
      attr_reader :the, :green, :dog, :sentence

      before do
        input = "the green dog"
        @the = SyntaxNode.new(input, 0..3)
        @green = SyntaxNode.new(input, 4..9)
        @dog = SyntaxNode.new(input, 10..13)
        @sentence = SyntaxNode.new(input, 0..13)

        cache.store_result(:the, the)
        cache.store_result(:color, green)
        cache.store_result(:dog, dog)
        cache.store_result(:sentence, sentence)
      end

      it "removes a single result that overlaps an expired range, leaving undisturbed results intact" do
        cache.should have_result(:the, 0)
        cache.should have_result(:color, 4)
        cache.should have_result(:dog, 10)

        cache.expire(green.interval, 0)

        cache.should have_result(:the, 0)
        cache.should_not have_result(:color, 4)
        cache.should have_result(:dog, 10)
      end
    end

    describe "with three results for the same rule stored on three seperate overlapping intervals" do
      attr_reader :a, :b, :c
      
      before do
        @a = SyntaxNode.new(input, 0...5)
        cache.store_result(:foo, a)

        @b = SyntaxNode.new(input, 3...10)
        cache.store_result(:foo, b)

        @c = SyntaxNode.new(input, 7...13)
        cache.store_result(:foo, c)
      end
      
      it "removes multiple results that overlap an expired range, correctly updating the surviving result with the length_change" do
        cache.get_result(:foo, 0).should == a
        cache.get_result(:foo, 3).should == b
        cache.get_result(:foo, 7).should == c

        cache.expire(3..7, 5)

        cache.should_not have_result(:foo, 0)
        cache.should_not have_result(:foo, 3)
        cache.should_not have_result(:foo, 7)
        cache.get_result(:foo, 12).should == c
        c.interval.should == (12...18)

        cache.expire(13..15, 0)
        cache.should_not have_result(:foo, 12)
      end
    end

    describe "when a result with children has been stored with with a non-local dependency on another result" do
      attr_reader :child, :epsilon_node, :predication_result, :parent, :non_local_dependency
      
      before do
        @child = SyntaxNode.new(input, 0...5)
        @epsilon_node = SyntaxNode.new(input, 5...5)
        @predication_result = SyntaxNode.new(input, 5..8)
        epsilon_node.dependencies.push(predication_result)
        @parent = SyntaxNode.new(input, 0...5, [child, epsilon_node])
        @non_local_dependency = TerminalParseFailure.new(5...15, 'x' * 10)

        parent.dependencies.push(non_local_dependency)
        parent.dependencies.should == [non_local_dependency]

        cache.store_result(:foo, parent)
      end

      it "expires the memoization when one of its children is expired" do
        cache.should have_result(:foo, 0)
        cache.expire(3..3, 0)
        cache.should_not have_result(:foo, 0)
      end
      
      it "expires the memoization when a child of one of its children is expired" do
        cache.should have_result(:foo, 0)
        cache.expire(7..7, 0)
        cache.should_not have_result(:foo, 0)
      end
      
      it "expired the memoization when the non-local dependency is expired" do
        cache.should have_result(:foo, 0)
        cache.expire(12..12, 0)
        cache.should_not have_result(:foo, 0)
      end
      
      it "relocates the unexpired results when there is a change in buffer length" do
        child_interval_before_expire = child.interval
        epsilon_node_interval_before_expire = epsilon_node.interval
        predication_result_interval_before_expire = predication_result.interval
        parent_interval_before_expire = parent.interval
        non_local_dependency_interval_before_expire = non_local_dependency.interval
        
        cache.expire(0..0, 5)
        
        child.interval.should == child_interval_before_expire.transpose(5)
        epsilon_node.interval.should == epsilon_node_interval_before_expire.transpose(5)
        predication_result.interval.should == predication_result_interval_before_expire.transpose(5)
        parent.interval.should == parent_interval_before_expire.transpose(5)
        non_local_dependency.interval.should == non_local_dependency_interval_before_expire.transpose(5)
      end
    end

    describe "with a results for the same rule with intervals 1..2 and 2..3" do
      attr_reader :result_1, :result_2

      before do
        @result_1 = ParseFailure.new(1..2)
        @result_2 = ParseFailure.new(2..3)
        cache.store_result(:foo, result_1)
        cache.store_result(:foo, result_2)
      end

      it "correctly relocates both results without one clobbering the other when it is relocated" do
        cache.get_result(:foo, 1).should == result_1
        cache.get_result(:foo, 2).should == result_2
        cache.expire(0..0, 1)
        cache.get_result(:foo, 2).should == result_1
        cache.get_result(:foo, 3).should == result_2
      end
    end
  end
end