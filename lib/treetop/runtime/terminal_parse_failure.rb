module Treetop
  module Runtime
    class TerminalParseFailure < ParseFailure
      attr_reader :expected_string

      def initialize(index, expected_string)
        super(index)
        @expected_string = expected_string
      end

      def to_s
        "String matching #{expected_string} expected."
      end
    end
  end
end
