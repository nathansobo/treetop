module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :dependencies, :dependents, :memoizations
      attr_accessor :interval, :parent, :registered, :result_cache
      alias :registered? :registered
      
      def initialize(interval)
        @interval = interval
        @dependencies = []
        @dependents = []
        @memoizations = []
      end

      def expire
        result_cache.schedule_result_deletion(self)
        memoizations.each do |memoization|
          result_cache.schedule_memoization_expiration(memoization)
        end
        dependents.each { |dependent| dependent.expire }
      end
      
      def relocate(length_change)
        memoizations.each { |memoization| memoization.relocate(length_change) }
        @interval = interval.transpose(length_change)
      end
    end
  end
end
