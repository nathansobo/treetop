module Treetop
  module Runtime
    class ParseResult
      attr_reader :dependent_results, :storages, :dependencies
      attr_accessor :interval, :parent
      
      def initialize(interval)
        @interval = interval
        @dependent_results = []
        @storages = []
        @dependencies = []
      end

      def expire(propagate_to_storages_and_parent)
        dependent_results.each { |dependent_result| dependent_result.expire(true) }
        if propagate_to_storages_and_parent
          storages.each { |storage| storage.expire(false) }
          parent.expire(true) if parent
        end
      end
    end
  end
end
