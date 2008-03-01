module Treetop
  module Runtime
    class SyntaxNode < ParseResult
      attr_reader :input, :elements

      def initialize(input, interval, elements = nil)
        super(interval)
        @input = input
        @interval = interval
        if @elements = elements
          elements.each do |element|
            element.parent = self
          end
        end
        @dependencies = elements if elements
      end

      def epsilon?
        interval.first == interval.last
      end

      def terminal?
        @elements.nil?
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

      def extension_modules
        local_extensions =
          class <<self
            included_modules-Object.included_modules
          end
        if local_extensions.size > 0
          local_extensions
        else
          []    # There weren't any; must be a literal node
        end
      end

      def inspect
        ellipsis = text_value.length > 15 ? '...' : ''
        "SyntaxNode(#{interval.inspect}, #{text_value[0..15]}#{ellipsis})"
      end
    end
  end
end