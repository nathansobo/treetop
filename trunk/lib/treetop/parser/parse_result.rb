module Treetop
  module Runtime
    class ParseResult
      attr_reader :input, :nested_failures
    
      def initialize(input, nested_results = [])
        @input = input
        @nested_failures = collect_nested_failures_at_maximum_index(nested_results)
      end
    
      def collect_nested_failures_at_maximum_index(results)
        maximum_index = 0
        nested_failures = []
    
        results.each do |result|
          next if result.nested_failures.empty?
          index_of_nested_failures = result.nested_failures.first.index
          if index_of_nested_failures > maximum_index
            maximum_index = index_of_nested_failures
            nested_failures = result.nested_failures
          elsif index_of_nested_failures == maximum_index
            nested_failures += result.nested_failures
          end
        end
      
        return nested_failures.uniq
      end
    end
  end
end