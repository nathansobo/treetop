module Treetop
  module Runtime
    class TerminalParseFailure
      attr_reader :index, :expected_string
      attr_accessor :parent
      
      def initialize(index, expected_string)
        @index = index
        @expected_string = expected_string
      end

      def to_s
        "String matching #{expected_string} expected."
      end

      def interval
        index..index
      end
    end
  end
end
