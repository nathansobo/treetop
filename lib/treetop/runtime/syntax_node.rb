module Treetop
  module Runtime
    class SyntaxNode < ParseResult
      attr_reader :input, :elements

      def initialize(input, interval, child_results = nil)
        super(interval)
        @input = input
        
        if child_results
          @dependencies = child_results
          @elements = child_results.map do |child_result|
            element = child_result.element
            element.parent = self
            element
          end
        end
      end

      def element
        self
      end

      def epsilon?
        interval.first == interval.last
      end

      def terminal?
        elements.nil?
      end

      def nonterminal?
        !terminal?
      end

      def text_value
        input[interval]
      end

      def empty?
	      interval.first == interval.last && interval.exclude_end?
      end

      def resume_index
        interval.last
      end

      def inspect
        ellipsis = text_value.length > 15 ? '...' : ''
        "SyntaxNode(#{interval.inspect}, #{text_value[0..15]}#{ellipsis})"
      end
    end
  end
end