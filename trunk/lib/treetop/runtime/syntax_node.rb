module Treetop
  module Runtime
    class SyntaxNode < ParseResult
      attr_reader :input, :interval
      
      def initialize(input, interval, elements = nil, nested_results = elements)
        super(input, nested_results || [])
        @interval = interval
        @elements = elements
      end
      
      def success?
        true
      end
    
      def failure?
        false
      end

      def terminal?
        @elements.nil?
      end
      
      def nonterminal?
        !terminal?
      end
      
      def elements
        @elements || [self]
      end
      
      def text_value
        input[interval]
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
    end
  end
end