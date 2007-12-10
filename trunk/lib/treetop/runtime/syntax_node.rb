module Treetop
  module Runtime
    class SyntaxNode
      attr_reader :input, :interval
      
      def initialize(input, interval, elements = nil)
        @input = input
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
    end
  end
end