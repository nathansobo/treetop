module Treetop
  module Runtime
    class TerminalParseFailure
      attr_reader :index, :expected_string
      
      def initialize(index, expected_string)
        @index = index
        @expected_string = expected_string
      end

      def line
        input.line_of(index)
      end
      
      def column
        input.column_of(index)
      end
      
      def to_s
        "String matching #{expected_string} expected at line #{line}, column #{column} (index #{index})."
      end    
    end
  end
end