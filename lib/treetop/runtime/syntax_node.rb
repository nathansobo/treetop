module Treetop
  module Runtime
    class SyntaxNode < ParseResult
      attr_reader :input, :elements

      def initialize(input, interval, child_results = nil)
        super(interval)
        @input = input
        @child_results = child_results
        set_elements_from_child_results_and_become_parent if child_results
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

      def index
        interval.first
      end

      def resume_index
        interval.last
      end

      def inspect
        if text_value
          ellipsis = text_value.length > 15 ? '...' : ''
          "SyntaxNode(#{interval.inspect}, #{text_value[0..15]}#{ellipsis})"
        else
          "SyntaxNode(text value is nil!)"
        end
      end

      def expire(expire_parent=false)
        super
        parent.expire(expire_parent) if expire_parent && parent
      end

      protected
      def set_elements_from_child_results_and_become_parent
        @elements = []
        child_results.each do |child_result|
          child_result.parent = self
          element = child_result.element
          element.parent = self
          elements.push(element)
        end
      end
    end
  end
end