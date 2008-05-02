require File.expand_path("#{File.dirname(__FILE__)}/../spec_helper")

module ParseResultSpec
  include Runtime

  describe "it retains the child results and dependencies", :shared => true do
    it "retains the result's child results" do
      child_results.each do |child_result|
        mock.proxy(child_result).retain(result_cache)
      end
      result.retain(result_cache)
    end

    it "retains the result's dependencies" do
      mock.proxy(dependency).retain(result_cache)
      result.retain(result_cache)
    end
  end

  describe "it releases the result's child results and dependencies", :shared => true do
    it "releases the result's child results" do
      child_results.each do |child_result|
        mock.proxy(child_result).release
      end
      result.release
    end

    it "releases the result's dependencies" do
      mock.proxy(dependency).release
      result.release
    end
  end

  describe ParseResult do
    attr_reader :input
    before do
      @input = ('a'..'z').to_a.join
    end

    describe "add_dependencies" do
      attr_reader :result, :dependencies
      before do
        @result = SyntaxNode.new(input, 0..10)
        @dependencies = [SyntaxNode.new(input, 10..15), SyntaxNode.new(input, 15..20)]
      end

      it "adds the given dependencies to the results #dependencies" do
        result.dependencies.should be_empty
        result.add_dependencies(dependencies)
        result.dependencies.should == dependencies
      end

      it "adds the result as a dependent of the added dependencies" do
        dependencies.each do |dependency|
          dependency.dependents.should be_empty
        end
        result.add_dependencies(dependencies)
        dependencies.each do |dependency|
          dependency.dependents.should == [result]
        end
      end
    end

    describe "#retain" do
      attr_reader :result_cache, :child_results, :dependency, :result

      before do
        @result_cache = ResultCache.new

        @child_results = [SyntaxNode.new(input, 0..5), SyntaxNode.new(input, 5..10)]
        @dependency = SyntaxNode.new(input, 10..15)
        @result = SyntaxNode.new(input, 0..10, child_results)
        result.add_dependencies([dependency])
      end

      describe "when the result has never been retained" do
        it "increments the result's refcount to 1" do
          result.refcount.should == 0
          result.retain(result_cache)
          result.refcount.should == 1
        end

        it "registers the result with the passed in ResultCache" do
          result_cache.results.should_not include(result)
          result.retain(result_cache)
          result_cache.results.should include(result)
        end

        it "keeps a reference to the ResultCache in which it has been retained" do
          result.retain(result_cache)
          result.result_cache.should == result_cache
        end

        it_should_behave_like "it retains the child results and dependencies"
      end

      describe "when the result has been retained" do
        before do
          result.retain(result_cache)
        end

        it "increments the result's refcount" do
          result.refcount.should == 1
          result.retain(result_cache)
          result.refcount.should == 2
        end

        it "does not attempt to register the result with the ResultCache" do
          dont_allow(result_cache.results).push(result)
          result.retain(result_cache)
        end
        
        it_should_behave_like "it retains the child results and dependencies"
      end
    end

    describe "#release" do
      attr_reader :result_cache, :child_results, :dependency, :result

      before do
        @result_cache = ResultCache.new

        @child_results = [SyntaxNode.new(input, 0..5), SyntaxNode.new(input, 5..10)]
        @dependency = SyntaxNode.new(input, 10..15)
        @result = SyntaxNode.new(input, 0..10, child_results)
        result.add_dependencies([dependency])
      end

      describe "when the result has been retained twice" do
        before do
          result.retain(result_cache)
          result.retain(result_cache)
        end

        it "decrements the refcount" do
          result.refcount.should == 2
          result.release
          result.refcount.should == 1
        end

        it_should_behave_like "it releases the result's child results and dependencies"
      end

      describe "when the result has been retained once" do
        before do
          result.retain(result_cache)
        end

        it "decrements the refcount to 0" do
          result.refcount.should == 1
          result.release
          result.refcount.should == 0
        end

        it "removes the result from the ResultCache in which it was retained" do
          result_cache.results.should include(result)
          result.release
          result_cache.results.should_not include(result)
        end

        it_should_behave_like "it releases the result's child results and dependencies"
      end
    end
  end
end