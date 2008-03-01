module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :dependencies, :dependents, :memoizations
      attr_accessor :interval, :parent, :registered, :node_cache
      alias :registered? :registered
      
      def initialize(interval)
        @interval = interval
        @dependencies = []
        @dependents = []
        @memoizations = []
      end

      def expire
        node_cache.delete_result(self)
        (dependents + memoizations).each { |dependent| dependent.expire }
      end
      
      def relocate(length_change)
        memoizations.each { |memoization| memoization.relocate(length_change) }
        @interval = interval.transpose(length_change)
      end
    end
  end
end
