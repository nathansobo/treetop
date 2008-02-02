require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NodeCacheSpec
  include Runtime

  describe NodeCache do
    attr_reader :cache, :input

    before do
      @cache = NodeCache.new
      @input = ('A'..'Z').to_a.join
    end

    describe "with a non-nil parse result stored on a name and interval" do
      attr_reader :node

      before do
        @node = SyntaxNode.new(input, 5..10)
        cache.store('foo', node.interval, node)
      end

      describe "#get" do
        it "returns the stored result given the correct name and start index" do
          cache.get('foo', 5).should == node
        end
      end

      describe "#has_result?" do
        it "returns true when given the correct name and start index" do
          cache.should have_result('foo', 5)
        end

        it "returns false when given a different name" do
          cache.should_not have_result('bar', 5)
        end

        it "returns false when given a different start index" do
          cache.should_not have_result('foo', 2)
        end
      end

      describe "#expire" do
        it "deletes the stored result from the cache when expiring an exactly overlapping interval" do
          cache.should have_result('foo', 5)
          cache.expire(5..10, 0)
          cache.should_not have_result('foo', 5)
        end

        it "deletes the stored result from the cache when expiring a partially overlapping interval" do
          cache.should have_result('foo', 5)
          cache.expire(8..14, 0)
          cache.should_not have_result('foo', 5)
        end

        it "does not delete the stored result from the cache when expiring a non-overlapping interval" do
          cache.should have_result('foo', 5)
          cache.expire(3..5, 0)
          cache.should have_result('foo', 5)
        end
      end
    end

    describe "with a nil parse result stored on a name and a zero-length interval" do
      before do
        cache.store('foo', 5..5, nil)
      end

      describe "#get" do
        it "returns the stored result given the correct name and start index" do
          cache.get('foo', 5).should == nil
        end
      end

      describe "#has_result?" do
        it "returns true when given the correct name and start index" do
          cache.has_result?('foo', 5).should be_true
        end

        it "returns false when given a different name" do
          cache.has_result?('bar', 5).should be_false
        end

        it "returns false when given a different start index" do
          cache.has_result?('foo', 2).should be_false
        end
      end
    end

    describe "with a three results for the same rule stored on three seperate intervals" do
      attr_reader :a, :b, :c
      
      before do
        @a = SyntaxNode.new(input, 0..5)
        cache.store('foo', a.interval, a)

        @b = SyntaxNode.new(input, 3..10)
        cache.store('foo', b.interval, b)

        @c = SyntaxNode.new(input, 7..13)
        cache.store('foo', c.interval, c)
      end

      it "removes multiple results that overlap an expired range, correctly updating the survivng result with the length_change" do
        cache.get('foo', 0).should == a
        cache.get('foo', 3).should == b
        cache.get('foo', 7).should == c

        cache.expire(3..7, 5)

        cache.should_not have_result('foo', 0)
        cache.should_not have_result('foo', 3)
        cache.should_not have_result('foo', 7)
        cache.get('foo', 12).should == c
        c.interval.should == (12..18)
      end
    end


  end
end