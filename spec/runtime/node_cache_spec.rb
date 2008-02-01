require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module NodeCacheSpec
  describe Runtime::NodeCache do
    attr_reader :cache

    before do
      @cache = Runtime::NodeCache.new
    end

    describe "with a non-nil parse result stored on a name and interval" do
      attr_reader :node

      before do
        @node = Object.new
        cache.store('foo', 5..10, node)
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
        it "deletes the stored result from the cache when expiring an overlapping interval" do
          pending
          cache.should have_result('foo', 5)
          cache.expire(5..10, 0)
          cache.should_not have_result('foo', 5)
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

    describe "" do

    end


  end
end