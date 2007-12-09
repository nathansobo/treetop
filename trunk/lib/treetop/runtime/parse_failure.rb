module Treetop
  module Runtime
    class ParseFailure < ParseResult
      attr_reader :index
    
      def initialize(input, index)
        super(input)
        @index = index
      end
      
      def line
        input.line_of(index)
      end
      
      def column
        input.column_of(index)
      end
    
      def success?
        false
      end
    
      def failure?
        true
      end
    
      def interval      
        @interval ||= (index...index)
      end    
    end
  end
end