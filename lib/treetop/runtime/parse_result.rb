module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :dependencies, :child_results, :dependents, :memoizations, :refcount
      attr_accessor :interval, :parent, :registered, :result_cache
      alias :registered? :registered
      
      def initialize(interval)
        @interval = interval
        @dependencies = []
        @dependents = []
        @memoizations = []
        @refcount = 0
      end

      def add_dependencies(new_dependencies)
        new_dependencies.each do |dependency|
          dependency.dependents.push(self)
        end
        dependencies.concat(new_dependencies)
      end

      def retain(result_cache)
        if refcount == 0
          result_cache.results.push(self)
          @result_cache = result_cache
        end

        descendants.each do |descendant|
          descendant.retain(result_cache)
        end
        @refcount += 1
      end
      
      def release
        descendants.each do |descendant|
          descendant.release
        end
        @refcount -= 1
        if refcount == 0
          result_cache.results.delete(self)
        end
      end

      def descendants
        (child_results || []) + dependencies
      end

      def expire(expire_parent=false)
        schedule_release_of_memoizations
        dependents.each { |dependent| dependent.expire(true) }
      end
      
      def relocate(length_change)
        memoizations.each { |memoization| memoization.relocate(length_change) }
        @interval = interval.transpose(length_change)
      end

      protected
      def schedule_release_of_memoizations
        memoizations.each do |memoization|
          result_cache.schedule_memoization_release(memoization)
        end
      end
    end
  end
end
