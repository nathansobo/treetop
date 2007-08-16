module Treetop2
  module Parser
    class SyntaxNode < ParseResult
      attr_reader :input, :interval
    
      def initialize(input, interval, nested_results = [])
        super(nested_results)
        @input = input
        @interval = interval
      end
    
      def update_nested_results(nested_results)
        new_nested_failures = collect_nested_failures_at_maximum_index(nested_results)
      
        return if new_nested_failures.empty?
        @nested_failures = new_nested_failures and return if nested_failures.empty?
      
        current_nested_failure_index = nested_failures.first.index
        new_nested_failure_index = new_nested_failures.first.index
      
        if new_nested_failure_index > current_nested_failure_index
          @nested_failures = new_nested_failures
        elsif new_nested_failure_index == current_nested_failure_index
          @nested_failures += new_nested_failures
        end
      end
        
      def text_value
        input[interval]
      end
    
      def success?
        true
      end
    
      def failure?
        false
      end
    
      def epsilon?
        false
      end
    end
  end
end